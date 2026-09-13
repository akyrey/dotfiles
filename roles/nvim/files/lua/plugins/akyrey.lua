-- Own plugins.
--
-- Note what is NOT here: akyrey/koseven-lsp and akyrey/laravel-lsp. Those are Go
-- repositories, not Neovim plugins - the old config had lazy.nvim cloning them
-- for no effect while the binaries actually used came from $GOPATH/bin. They
-- are now installed by the Ansible role with `go install`, and configured in
-- lsp/koseven_lsp.lua and lsp/laravel_lsp.lua.
return {
  -- Reorders comparison operands into a consistent style (Yoda conditions etc).
  {
    "akyrey/condition-order.nvim",
    ft = { "php", "go" },
    opts = {},
  },

  -- Navigate OpenAPI specs and cross-reference them with Laravel routes.
  {
    "akyrey/openapi-navigator.nvim",
    ft = { "yaml", "json" },
    opts = {
      laravel = {
        cmd = { "./xenv", "artisan", "route:list", "--json" },
      },
    },
  },
}
