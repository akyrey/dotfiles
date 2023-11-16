-- Parser generator and parsing library
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        cmd = { "TSUpdateSync" },
        config = function()
            require("akyrey.config.treesitter").setup()
        end,
        event = { "BufReadPost", "BufNewFile" },
    },
    { "p00f/nvim-ts-rainbow",   lazy = true },
    { "windwp/nvim-ts-autotag", lazy = true },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("akyrey.config.treesitter-context").setup()
        end,
        event = "VeryLazy",
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "VeryLazy",
    },
    {
        "nvim-treesitter/playground",
        event = "VeryLazy",
    },
}
