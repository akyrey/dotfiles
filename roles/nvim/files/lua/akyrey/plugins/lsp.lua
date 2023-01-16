return {
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-lspconfig.nvim",
        },
        lazy = true,
    },
    -- Automatically install LSPs to stdpath for neovim
    {
        "williamboman/mason.nvim",
        config = function()
            require("akyrey.config.mason").setup()
        end,
    },
    { "williamboman/mason-lspconfig.nvim", lazy = true },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "plenary.nvim",
        },
        lazy = true,
    },
    { "jayp0521/mason-null-ls.nvim", lazy = true },
    { "jayp0521/mason-nvim-dap.nvim", lazy = true },

    {
        "ThePrimeagen/refactoring.nvim",
        config = function()
            require("akyrey.config.refactoring").setup()
        end,
        dependencies = {
            "plenary.nvim",
            "nvim-treesitter",
        },
        lazy = true,
    },

    -- Useful status updates for LSP
    { "j-hui/fidget.nvim", lazy = true },

    -- Additional lua configuration, makes nvim stuff amazing
    { "folke/neodev.nvim", lazy = true },

    { "simrat39/rust-tools.nvim", lazy = true },
}
