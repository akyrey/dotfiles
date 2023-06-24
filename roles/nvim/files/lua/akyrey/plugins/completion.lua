return {
    {
        "hrsh7th/nvim-cmp",
        config = function()
            require("akyrey.config.cmp").setup()
        end,
        dependencies = {
            "cmp_luasnip",
            "cmp-buffer",
            "cmp-nvim-lsp",
            "cmp-nvim-lsp-signature-help",
            "cmp-path",
            "cmp-nvim-lua",
            "cmp-spell",
            "cmp-cmdline",
            "cmp-tabnine",
            "cmp-npm",
            "cmp-conventionalcommits",
            "cmp-treesitter",
        },
        event = { "InsertEnter", "CmdlineEnter" },
    },
    { "saadparwaiz1/cmp_luasnip", lazy = true },
    { "hrsh7th/cmp-buffer", lazy = true },
    { "hrsh7th/cmp-nvim-lsp", lazy = true },
    { "hrsh7th/cmp-nvim-lsp-signature-help", lazy = true },
    { "hrsh7th/cmp-path", lazy = true },
    { "hrsh7th/cmp-nvim-lua", lazy = true },
    { "f3fora/cmp-spell", lazy = true },
    { "hrsh7th/cmp-cmdline", lazy = true },
    {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        lazy = true,
    },
    { "David-Kunz/cmp-npm", lazy = true },
    { "davidsierradz/cmp-conventionalcommits", lazy = true },
    { "ray-x/cmp-treesitter", lazy = true },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            local utils = require("akyrey.utils")
            local paths = {}
            paths[#paths + 1] = utils.join_paths(vim.call("stdpath", "data"), "site", "pack", "packer", "start", "friendly-snippets")
            local user_snippets = utils.join_paths(vim.call("stdpath", "config"), "snippets")
            if utils.is_directory(user_snippets) then
                paths[#paths + 1] = user_snippets
            end
            require("luasnip.loaders.from_lua").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load {
                paths = paths,
            }
            require("luasnip.loaders.from_snipmate").lazy_load()
        end,
        dependencies = {
            "friendly-snippets",
        },
        event = "InsertEnter",
    },
    { "rafamadriz/friendly-snippets", lazy = true },
    -- Automatically insert pairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("akyrey.config.autopairs").setup()
        end,
        event = "InsertEnter",
    },
    -- Insert char surround targets
    {
        "kylechui/nvim-surround",
        config = function()
            require("akyrey.config.nvim-surround").setup()
        end,
        event = "VeryLazy",
    },
    {
        "vuki656/package-info.nvim",
        config = function()
            require("akyrey.config.package-info").setup()
        end,
        dependencies = {
            "nui.nvim",
        },
        ft = "json",
        lazy = true,
    },
    { "MunifTanjim/nui.nvim", lazy = true },
}