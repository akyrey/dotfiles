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
            local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
            if opts.inlay_hints.enabled and inlay_hint then
                utils.on_attach(function(client, buffer)
                    if client.server_capabilities.inlayHintProvider then
                        inlay_hint(buffer, true)
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
                        { name = "DiagnosticSignWarn",  text = "" },
                        { name = "DiagnosticSignHint",  text = "" },
                        { name = "DiagnosticSignInfo",  text = "" },
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
                rust_analyzer = function(_, opts)
                    require("rust-tools").setup({ server = opts })
                    return true
                end,
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
            ensure_installed = {},
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
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvim-lua/plenary.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local null_ls = require("null-ls")
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    null_ls.builtins.diagnostics.eslint_d,
                    null_ls.builtins.formatting.prettierd,
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
                    spinner = "dots_pulse",  -- animation shown when tasks are ongoing
                    done = "✔",            -- character shown when all tasks are complete
                    commenced = "Started",   -- message shown when task starts
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
