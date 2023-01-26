return {
    {
        "tpope/vim-dadbod",
        cmd = { "DB", "DBUI", "DBUIToggle" },
        dependencies = {
            "vim-dadbod-completion",
            "vim-dadbod-ui",
        },
        lazy = true,
    },
    { "kristijanhusak/vim-dadbod-completion", lazy = true },
    { "kristijanhusak/vim-dadbod-ui", lazy = true },
    {
        "lifepillar/pgsql.vim",
        config = function()
            vim.g.sql_type_default = "pgsql"
        end,
        ft = "sql",
        lazy = true,
    },
}
