local M = {}

function M.setup()
    local ok, nvimtree = pcall(require, "nvim-tree")
    local ok_lsp, lsp_file_operations = pcall(require, "lsp-file-operations")

    if not ok or not ok_lsp then
        return
    end

    local api = require("nvim-tree.api")
    local HEIGHT_RATIO = 0.9
    local WIDTH_RATIO = 0.9
    -- Telescope action menu
    local tree_actions = {
        {
            name = "Create node",
            handler = api.fs.create,
        },
        {
            name = "Remove node",
            handler = api.fs.remove,
        },
        {
            name = "Trash node",
            handler = api.fs.trash,
        },
        {
            name = "Rename node",
            handler = api.fs.rename,
        },
        {
            name = "Fully rename node",
            handler = api.fs.rename_sub,
        },
        {
            name = "Copy",
            handler = api.fs.copy.node,
        },
    }
    local function tree_actions_menu(node)
        local entry_maker = function(menu_item)
            return {
                value = menu_item,
                ordinal = menu_item.name,
                display = menu_item.name,
            }
        end

        local finder = require("telescope.finders").new_table({
            results = tree_actions,
            entry_maker = entry_maker,
        })

        local sorter = require("telescope.sorters").get_generic_fuzzy_sorter()

        local default_options = {
            finder = finder,
            sorter = sorter,
            attach_mappings = function(prompt_buffer_number)
                local actions = require("telescope.actions")

                -- On item select
                actions.select_default:replace(function()
                    local state = require("telescope.actions.state")
                    local selection = state.get_selected_entry()
                    -- Closing the picker
                    actions.close(prompt_buffer_number)
                    -- Executing the callback
                    selection.value.handler(node)
                end)

                -- The following actions are disabled in this example
                -- You may want to map them too depending on your needs though
                actions.add_selection:replace(function()
                end)
                actions.remove_selection:replace(function()
                end)
                actions.toggle_selection:replace(function()
                end)
                actions.select_all:replace(function()
                end)
                actions.drop_all:replace(function()
                end)
                actions.toggle_all:replace(function()
                end)

                return true
            end,
        }

        -- Opening the menu
        require("telescope.pickers").new({ prompt_title = "Tree menu" }, default_options):find()
    end
    local function edit_or_open()
        local node = api.tree.get_node_under_cursor()

        if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
        else
            -- open file
            api.node.open.edit()
            -- Close the tree if file was opened
            api.tree.close()
        end
    end

    -- open as vsplit on current node
    local function vsplit_preview()
        local node = api.tree.get_node_under_cursor()

        if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
        else
            -- open file as vsplit
            api.node.open.vertical()
        end

        -- Finally refocus on tree if it was lost
        api.tree.focus()
    end
    local function on_attach(bufnr)
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "<C-Space>", tree_actions_menu, opts("Menu actions"))
        vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
        vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
        vim.keymap.set("n", "h", api.tree.close, opts("Close"))
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
    end

    local icons = require("akyrey.config.icons").diagnostics
    nvimtree.setup({
        diagnostics = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = true,
            debounce_delay = 50,
            severity = {
                min = vim.diagnostic.severity.HINT,
                max = vim.diagnostic.severity.ERROR,
            },
            icons = {
                hint = icons.Hint,
                info = icons.Info,
                warning = icons.Warn,
                error = icons.Error,
            },
        },
        filters = {
        git_ignored = false,
            custom = {
                "^.git$",
            },
        },
        live_filter = {
            prefix = "[FILTER]: ",
            always_show_folders = false, -- Turn into false from true by default
        },
        on_attach = on_attach,
        view = {
            centralize_selection = true,
            float = {
                enable = true,
                open_win_config = function()
                    local screen_w = vim.opt.columns:get()
                    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                    local window_w = screen_w * WIDTH_RATIO
                    local window_h = screen_h * HEIGHT_RATIO
                    local window_w_int = math.floor(window_w)
                    local window_h_int = math.floor(window_h)
                    local center_x = (screen_w - window_w) / 2
                    local center_y = ((vim.opt.lines:get() - window_h) / 2)
                        - vim.opt.cmdheight:get()
                    return {
                        border = "rounded",
                        relative = "editor",
                        row = center_y,
                        col = center_x,
                        width = window_w_int,
                        height = window_h_int,
                    }
                end,
            },
            width = function()
                return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
            end,
        },
    })

    lsp_file_operations.setup()
end

return M
