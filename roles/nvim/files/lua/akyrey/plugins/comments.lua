return {
    -- Comment multiple lines
    {
        "numToStr/Comment.nvim",
        -- TODO: add configuration
        -- config = function()
        --     require("akyrey.config.comment").setup()
        -- end,
        event = "BufRead",
    },
    -- Highlight todos
    {
        "folke/todo-comments.nvim",
        -- TODO: add configuration
        -- config = function()
        --     require("akyrey.config.todo-comments").setup()
        -- end,
        dependencies = {
            "plenary.nvim",
        },
        event = "VeryLazy",
    },
}
