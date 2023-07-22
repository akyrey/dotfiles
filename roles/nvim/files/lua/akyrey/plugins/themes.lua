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
        "akinsho/bufferline.nvim",
        branch = "main",
        config = function()
            require("akyrey.config.bufferline").setup()
        end,
    },
    "stevearc/dressing.nvim",
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
}
