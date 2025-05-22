return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.default_format_opts.timeout_ms = 20000
    opts.formatters_by_ft.go = { "gofumpt", "goimports_reviser" }
    opts.formatters_by_ft.php = { "pint", "php_cs_fixer" }
    opts.formatters_by_ft.blade = { "blade-formatter", "rustywind" }
  end,
}
