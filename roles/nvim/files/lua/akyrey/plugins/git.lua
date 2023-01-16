-- Git related
return {
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("akyrey.config.gitsigns").setup()
        end,
        event = "BufRead",
    },
    {
        "sindrets/diffview.nvim",
        dependencies = {
            "plenary.nvim",
        },
        event = "BufRead",
    },
    {
        "ThePrimeagen/git-worktree.nvim",
        event = "VeryLazy",
        lazy = true,
    },
}
