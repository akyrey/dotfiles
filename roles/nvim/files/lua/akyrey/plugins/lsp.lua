return {
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
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
    },
    -- Automatically install LSPs to stdpath for neovim
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        cmd = "Mason",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    },
                },
            })
        end,
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
        opts = function()
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
}
