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
            require("akyrey.config.colorizer").setup()
        end,
        event = "BufRead",
    },
}
