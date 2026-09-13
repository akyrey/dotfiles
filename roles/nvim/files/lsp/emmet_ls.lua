-- Expands emmet abbreviations. Deliberately broad filetype list so it works in
-- blade templates as well as plain HTML.
return {
  cmd = { "emmet-ls", "--stdio" },
  filetypes = {
    "astro",
    "blade",
    "css",
    "eruby",
    "html",
    "htmldjango",
    "javascriptreact",
    "less",
    "pug",
    "sass",
    "scss",
    "svelte",
    "typescriptreact",
    "vue",
  },
  root_markers = { ".git" },
}
