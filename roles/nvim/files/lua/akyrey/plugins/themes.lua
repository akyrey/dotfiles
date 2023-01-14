return {
    -- Catppuccin theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    "lukas-reineke/indent-blankline.nvim",
    {
        "nvim-lualine/lualine.nvim",
        -- TODO: add configuration
        -- config = function()
        --     require("akyrey.config.lualine").setup()
        -- end,
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
        event = "BufRead",
    },
}
