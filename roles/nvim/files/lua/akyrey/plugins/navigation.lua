return {
    {
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
        config = function()
            require("akyrey.config.nvimtree").setup()
        end,
        dependencies = {
            "antosha417/nvim-lsp-file-operations",
        },
        event = "User DirOpened",
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        config = function()
            require("akyrey.config.telescope").setup()
        end,
        dependencies = {
            "plenary.nvim",
            "telescope-fzf-native.nvim",
            "ThePrimeagen/refactoring.nvim",
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
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
        }
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
    {
        "folke/which-key.nvim",
        config = function()
            require("akyrey.config.which-key").setup()
        end,
        event = "VeryLazy",
    },
}
