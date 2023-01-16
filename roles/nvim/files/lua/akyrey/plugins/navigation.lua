return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        config = function()
            require("akyrey.config.telescope").setup()
        end,
        dependencies = {
            "plenary.nvim",
            "telescope-fzf-native.nvim",
            "refactoring.nvim",
            "git-worktree.nvim",
        },
        lazy = true,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        lazy = true,
    },
    {
        "weilbith/nvim-code-action-menu",
        cmd = "CodeActionMenu",
        lazy = true,
    },
    -- Mark and easily navigate through files
    "ThePrimeagen/harpoon",
    {
        "folke/which-key.nvim",
        config = function()
            require("akyrey.config.which-key").setup()
        end,
        event = "VeryLazy",
    },
}
