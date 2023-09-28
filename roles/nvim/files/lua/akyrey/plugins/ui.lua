return {
    -- Catppuccin theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("akyrey.config.indent-blankline").setup()
        end,
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("akyrey.config.lualine").setup()
        end,
        dependencies = {
            "nvim-web-devicons",
        },
    },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
    -- Color highlighter
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
                '*',                      -- Highlight all files, but customize some others.
                css = { rgb_fn = true, }, -- Enable parsing rgb(...) functions in css.
            })
        end,
        event = "BufRead",
    },
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    vim.notify = require("notify")
                end,
            })
        end,
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
    },
}
