-- Overrides on top of nvim-lspconfig's lsp/emmet_ls.lua: lspconfig's filetype
-- list plus blade, so abbreviations expand in blade templates too.
return {
  filetypes = {
    "astro",
    "blade",
    "css",
    "eruby",
    "html",
    "htmlangular",
    "htmldjango",
    "javascriptreact",
    "less",
    "pug",
    "sass",
    "scss",
    "svelte",
    "templ",
    "typescriptreact",
    "vue",
  },
}
