-- Overrides on top of nvim-lspconfig's lsp/html.lua.
return {
  init_options = {
    provideFormatter = false, -- prettier handles formatting
  },
}
