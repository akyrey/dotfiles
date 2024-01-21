return {
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        ---@param opts PluginLspOpts
        config = function(_, opts)
            local utils = require("akyrey.lsp.utils")

            -- Setup global keymaps
            utils.on_attach(function(client, buffer)
                utils.add_lsp_buffer_keybindings(client, buffer)
            end)
            local register_capability = vim.lsp.handlers["client/registerCapability"]
            vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
                local ret = register_capability(err, res, ctx)
                local client_id = ctx.client_id
                ---@type lsp.Client?
                local client = vim.lsp.get_client_by_id(client_id)
                local buffer = vim.api.nvim_get_current_buf()
                utils.add_lsp_buffer_keybindings(client, buffer)
                return ret
            end

            -- Setup document highlight
            utils.on_attach(function(client, buffer)
                utils.setup_document_highlight(client, buffer)
            end)

            -- Setup codelens refresh
            utils.on_attach(function(client, buffer)
                utils.setup_codelens_refresh(client, buffer)
            end)

            -- Diagnostics
            local float = {
                focusable = true,
                style = "minimal",
                border = "rounded",
            }
            for _, info in pairs(opts.diagnostics.signs.values) do
                vim.fn.sign_define(info.text, { text = info.text, texthl = info.name, numhl = "" })
            end
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float)
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float)

            -- Inlay hints
            if opts.inlay_hints.enabled then
                utils.on_attach(function(client, buffer)
                    if client.supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(buffer, true)
                    end
                end)
            end

            -- Setup function
            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            --- @type lsp.ClientCapabilities
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {}
            )
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.completion.completionItem.resolveSupport = {
                properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                },
            }

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available thourgh mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
            end
        end,
        dependencies = {
            -- Access to schemastore catalog for completion on json and yaml
            "b0o/schemastore.nvim",
            -- Additional lua configuration, makes nvim stuff amazing
            { "folke/neodev.nvim", opts = {} },
            "hrsh7th/cmp-nvim-lsp",
            "lspcontainers/lspcontainers.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        ---@class PluginLspOpts
        opts = {
            diagnostics = {
                signs = {
                    active = true,
                    values = {
                        { name = "DiagnosticSignError", text = "" },
                        { name = "DiagnosticSignWarn", text = "" },
                        { name = "DiagnosticSignHint", text = "" },
                        { name = "DiagnosticSignInfo", text = "" },
                    },
                },
                virtual_text = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                    format = function(d)
                        local code = d.code or (d.user_data and d.user_data.lsp.code)
                        if code then
                            return string.format("%s [%s]", d.message, code):gsub("1. ", "")
                        end
                        return d.message
                    end,
                },
            },
            -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the inlay hints.
            inlay_hints = {
                enabled = true,
            },
            -- LSP Server Settings
            ---@type lspconfig.options
            servers = require("akyrey.lsp.config").server,
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                gopls = function(_, _)
                    -- workaround for gopls not supporting semanticTokensProvider
                    -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
                    require("akyrey.lsp.utils").on_attach(function(client, _)
                        if client.name == "gopls" then
                            if not client.server_capabilities.semanticTokensProvider then
                                local semantic = client.config.capabilities.textDocument.semanticTokens
                                client.server_capabilities.semanticTokensProvider = {
                                    full = true,
                                    legend = {
                                        tokenTypes = semantic.tokenTypes,
                                        tokenModifiers = semantic.tokenModifiers,
                                    },
                                    range = true,
                                }
                            end
                        end
                    end)
                    -- end workaround
                end,
                -- intelephense = function()
                --     require('lspconfig').intelephense.setup {
                --         before_init = function(params)
                --             params.processId = vim.NIL
                --         end,
                --         cmd = require('lspcontainers').command('intelephense'),
                --         on_attach = require("akyrey.lsp.utils").on_attach,
                --         root_dir = require('lspconfig/util').root_pattern("composer.json", ".git", vim.fn.getcwd()),
                --     }
                --     return true
                -- end,
                rust_analyzer = function(_, opts)
                    require("rust-tools").setup({ server = opts })
                    return true
                end,
                tsserver = function()
                    return true
                end,
                -- tsserver = function(_, opts)
                --     require("typescript").setup({ server = opts })
                --     return true
                -- end,
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            on_attach = function()
                vim.keymap.set("n", "<leader>go", "<cmd>TSToolsOrganizeImports<CR>",
                    { desc = "LSP: Or[g]anize Imp[o]rts" })
            end,
            settings = {
                -- spawn additional tsserver instance to calculate diagnostics on it
                separate_diagnostic_server = true,
                -- "change"|"insert_leave" determine when the client asks the server about diagnostic
                publish_diagnostic_on = "insert_leave",
                -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
                -- "remove_unused_imports"|"organize_imports") -- or string "all"
                -- to include all supported code actions
                -- specify commands exposed as code_actions
                expose_as_code_action = "all",
                -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
                -- not exists then standard path resolution strategy is applied
                tsserver_path = nil,
                -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
                -- (see 💅 `styled-components` support section)
                tsserver_plugins = {},
                -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
                -- memory limit in megabytes or "auto"(basically no limit)
                tsserver_max_memory = "auto",
                -- described below
                tsserver_format_options = {
                    indentSize = vim.o.shiftwidth,
                    convertTabsToSpaces = vim.o.expandtab,
                    tabSize = vim.o.tabstop,
                },
                tsserver_file_preferences = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
                -- locale of all tsserver messages, supported locales you can find here:
                -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
                tsserver_locale = "en",
                -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
                complete_function_calls = true,
                include_completions_with_insert_text = true,
                -- CodeLens
                -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
                -- possible values: ("off"|"all"|"implementations_only"|"references_only")
                code_lens = "off",
                -- by default code lenses are displayed on all referencable values and for some of you it can
                -- be too much this option reduce count of them by removing member references from lenses
                disable_member_code_lens = true,
                -- JSXCloseTag
                -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-auto-tag,
                -- that maybe have a conflict if enable this feature. )
                jsx_close_tag = {
                    enable = false,
                    filetypes = { "javascriptreact", "typescriptreact" },
                },
            },
        },
    },
    -- Automatically install LSPs to stdpath for neovim
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        cmd = "Mason",
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
        opts = {
            ensure_installed = {
                "js-debug-adapter",
            },
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvim-lua/plenary.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local null_ls = require("null-ls")
            return {
                -- debug = true,
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    -- Typescript
                    null_ls.builtins.diagnostics.eslint_d.with({
                        extra_filetypes = { "astro" }
                    }),
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.prettier.with({
                        filetypes = { "astro" },
                    }),
                    -- Go
                    null_ls.builtins.code_actions.gomodifytags,
                    null_ls.builtins.code_actions.impl,
                    null_ls.builtins.formatting.gofumpt,
                    null_ls.builtins.formatting.goimports_reviser,
                    -- SQL
                    null_ls.builtins.formatting.sqlfmt,
                    -- PHP
                    null_ls.builtins.diagnostics.phpcs,
                    null_ls.builtins.formatting.phpcsfixer,
                },
            }
        end,
    },

    {
        "ThePrimeagen/refactoring.nvim",
        config = function()
            require("refactoring").setup({})
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },

    -- Useful status updates for LSP
    {
        "j-hui/fidget.nvim",
        opts = function() -- This is the same as calling require("fidget").setup({...})
            return {
                text = {
                    spinner = "dots_pulse", -- animation shown when tasks are ongoing
                    done = "✔", -- character shown when all tasks are complete
                    commenced = "Started", -- message shown when task starts
                    completed = "Completed", -- message shown when task completes
                },
                align = {
                    bottom = true, -- align fidgets along bottom edge of buffer
                    right = true,  -- align fidgets along right edge of buffer
                },
                timer = {
                    spinner_rate = 125,  -- frame rate of spinner animation, in ms
                    fidget_decay = 2000, -- how long to keep around empty fidget, in ms
                    task_decay = 1000,   -- how long to keep around completed task, in ms
                },
                window = {
                    relative = "win", -- where to anchor, either "win" or "editor"
                    blend = 0,        -- &winblend for the window
                    zindex = nil,     -- the zindex value for the window
                    border = "none",  -- style of border for the fidget window
                },
                fmt = {
                    leftpad = true,       -- right-justify text in fidget box
                    stack_upwards = true, -- list of tasks grows upwards
                    max_width = 0,        -- maximum width of the fidget box
                    fidget =              -- function to format fidget title
                        function(fidget_name, spinner)
                            return string.format("%s %s", spinner, fidget_name)
                        end,
                    task = -- function to format each task line
                        function(task_name, message, percentage)
                            return string.format(
                                "%s%s [%s]",
                                message,
                                percentage and string.format(" (%s%%)", percentage) or "",
                                task_name
                            )
                        end,
                },
                debug = {
                    logging = false, -- whether to enable logging, for debugging
                    strict = false,  -- whether to interpret LSP strictly
                },
            }
        end,
        event = "LspAttach",
        tag = "legacy",
    },

    { "simrat39/rust-tools.nvim" },
    { "b0o/schemastore.nvim" },
}
