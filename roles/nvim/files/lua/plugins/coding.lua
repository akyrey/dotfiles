return {
  {
    "akyrey/condition-order.nvim",
    ft = { "php", "go" },
    opts = {},
  },
  {
    "akyrey/openapi-navigator.nvim",
    ft = { "yaml", "json" },
    opts = {
      laravel = {
        cmd = { "./xenv", "artisan", "route:list", "--json" },
      },
    },
  },
  {
    "akyrey/koseven-lsp",
  },
  {
    "akyrey/laravel-ls",
    name = "laravel-lsp",
  },
}
