return {
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("akyrey.config.toggleterm").setup()
        end,
        event = "VeryLazy",
        version = "*",
    },
}
