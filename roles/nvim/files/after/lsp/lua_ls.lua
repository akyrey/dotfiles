-- Overrides on top of nvim-lspconfig's lsp/lua_ls.lua. Workspace library setup
-- is handled by lazydev.nvim, so there is no manual runtimepath scanning here.
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim", "Snacks" } },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      format = { enable = false }, -- stylua does the formatting
    },
  },
}
