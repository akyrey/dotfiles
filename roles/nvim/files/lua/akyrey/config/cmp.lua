local M = {}

M.setup = function()
    local c_ok, cmp = pcall(require, "cmp")
    local l_ok, luasnip = pcall(require, "luasnip")

    if not c_ok or not l_ok then
        return
    end

    -- Taken from LunarVim config

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    ---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
    ---@param dir number 1 for forward, -1 for backward; defaults to 1
    ---@return boolean true if a jumpable luasnip field is found while inside a snippet
    local function jumpable(dir)
        local win_get_cursor = vim.api.nvim_win_get_cursor
        local get_current_buf = vim.api.nvim_get_current_buf

        ---sets the current buffer's luasnip to the one nearest the cursor
        ---@return boolean true if a node is found, false otherwise
        local function seek_luasnip_cursor_node()
            -- TODO(kylo252): upstream this
            -- for outdated versions of luasnip
            if not luasnip.session.current_nodes then
                return false
            end

            local node = luasnip.session.current_nodes[get_current_buf()]
            if not node then
                return false
            end

            local snippet = node.parent.snippet
            local exit_node = snippet.insert_nodes[0]

            local pos = win_get_cursor(0)
            pos[1] = pos[1] - 1

            -- exit early if we're past the exit node
            if exit_node then
                local exit_pos_end = exit_node.mark:pos_end()
                if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
                    snippet:remove_from_jumplist()
                    luasnip.session.current_nodes[get_current_buf()] = nil

                    return false
                end
            end

            node = snippet.inner_first:jump_into(1, true)
            while node ~= nil and node.next ~= nil and node ~= snippet do
                local n_next = node.next
                local next_pos = n_next and n_next.mark:pos_begin()
                local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
                    or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

                -- Past unmarked exit node, exit early
                if n_next == nil or n_next == snippet.next then
                    snippet:remove_from_jumplist()
                    luasnip.session.current_nodes[get_current_buf()] = nil

                    return false
                end

                if candidate then
                    luasnip.session.current_nodes[get_current_buf()] = node
                    return true
                end

                local ok
                ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
                if not ok then
                    snippet:remove_from_jumplist()
                    luasnip.session.current_nodes[get_current_buf()] = nil

                    return false
                end
            end

            -- No candidate, but have an exit node
            if exit_node then
                -- to jump to the exit node, seek to snippet
                luasnip.session.current_nodes[get_current_buf()] = snippet
                return true
            end

            -- No exit node, exit from snippet
            snippet:remove_from_jumplist()
            luasnip.session.current_nodes[get_current_buf()] = nil
            return false
        end

        if dir == -1 then
            return luasnip.in_snippet() and luasnip.jumpable(-1)
        else
            return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
        end
    end

    local vim_item_symbol = {
        Array         = " ",
        Boolean       = "󰨙 ",
        Class         = " ",
        Codeium       = "󰘦 ",
        Color         = " ",
        Control       = " ",
        Collapsed     = " ",
        Constant      = "󰏿 ",
        Constructor   = " ",
        Copilot       = " ",
        Enum          = " ",
        EnumMember    = " ",
        Event         = " ",
        Field         = " ",
        File          = " ",
        Folder        = " ",
        Function      = "󰊕 ",
        Interface     = " ",
        Key           = " ",
        Keyword       = " ",
        Method        = "󰊕 ",
        Module        = " ",
        Namespace     = "󰦮 ",
        Null          = " ",
        Number        = "󰎠 ",
        Object        = " ",
        Operator      = " ",
        Package       = " ",
        Property      = " ",
        Reference     = " ",
        Snippet       = " ",
        String        = " ",
        Struct        = "󰆼 ",
        TabNine       = "󰏚 ",
        Text          = " ",
        TypeParameter = " ",
        Unit          = " ",
        Value         = " ",
        Variable      = "󰀫 ",
    }

    cmp.setup({
        enabled = function()
            local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
            if buftype == "prompt" then
                return false
            end

            return true
        end,
        completion = {
            ---@usage The minimum length of a word to complete on.
            keyword_length = 1,
        },
        experimental = {
            ghost_text = false,
            native_menu = false,
        },
        confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        window = {
            documentation = {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            },
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert {
            ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { "i" }),
            ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }, { "i" }),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-y>"] = cmp.mapping {
                i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
                c = function(fallback)
                    if cmp.visible() then
                        cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                    else
                        fallback()
                    end
                end,
            },
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                elseif jumpable(1) then
                    luasnip.jump(1)
                elseif has_words_before() then
                    -- cmp.complete()
                    fallback()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    local confirm_opts = vim.deepcopy({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }) -- avoid mutating the original opts below
                    local is_insert_mode = function()
                        return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
                    end
                    if is_insert_mode() then -- prevent overwriting brackets
                        confirm_opts.behavior = cmp.ConfirmBehavior.Insert
                    end
                    local entry = cmp.get_selected_entry()
                    local is_copilot = entry and entry.source.name == "copilot"
                    if is_copilot then
                        confirm_opts.behavior = cmp.ConfirmBehavior.Replace
                        confirm_opts.select = true
                    end
                    if cmp.confirm(confirm_opts) then
                        return -- success, exit early
                    end
                end
                fallback() -- if not exited early, always fallback
            end),
        },
        sources = cmp.config.sources(
            {
                -- Copilot Source
                { name = "copilot" },
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "nvim_lsp_signature_help" },
                { name = "nvim_lua" },
                { name = "path" },
                { name = "treesitter" },
                { name = "npm",                    keyword_length = 4 },
            },
            {
                { name = "buffer" },
                { name = "spell" },
            }
        ),
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = string.format("%s %s", vim_item_symbol[vim_item.kind], vim_item.kind)
                -- set a name for each source
                vim_item.menu = ({
                    copilot = "   (Copilot)",
                    buffer = "   (Buffer)",
                    nvim_lsp = "   (LSP)",
                    luasnip = "   (Snippet)",
                    nvim_lua = "   (Lua)",
                    cmp_tabnine = "   (T9)",
                    path = "   (Path)",
                    spell = "   (Spell)",
                    calc = "   (Calc)",
                    conventionalcommits = "   (CC)",
                    treesitter = " 🌲  (TS)",
                })[entry.source.name]
                return vim_item;
            end
        },
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
            { name = "conventionalcommits" },
        }, {
            { name = "buffer" },
        })
    })

    -- Use cmdline & path source for ':'
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" }
        }, {
            { name = "cmdline" }
        }),
    })

    -- Use buffer source for `/` and `?`
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- Automatically insert parentheses after selecting a method/function
    local autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    if not autopairs_ok then
        return
    end
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
