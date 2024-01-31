return {
    -- Comment multiple lines
    {
        "numToStr/Comment.nvim",
        config = function()
            require("akyrey.config.comment").setup()
        end,
        event = "BufRead",
    },
    -- Highlight todos
    {
        "folke/todo-comments.nvim",
        config = function()
            require("akyrey.config.todo-comments").setup()
        end,
        dependencies = {
            "plenary.nvim",
        },
        event = "VeryLazy",
    },
    {
        "danymat/neogen",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            snippet_engine = "luasnip",
        },
    },
}
