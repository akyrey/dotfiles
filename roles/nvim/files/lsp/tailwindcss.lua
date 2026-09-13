local lsp = require("util.lsp")

return {
  cmd = lsp.node_cmd("tailwindcss-language-server"),
  filetypes = { "blade", "css", "html", "javascriptreact", "less", "php", "sass", "scss", "typescriptreact", "vue" },
  -- Never start outside a project that actually uses tailwind.
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
  },
  workspace_required = true,
  settings = {
    tailwindCSS = {
      validate = true,
      classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
      includeLanguages = {
        blade = "html",
        php = "html",
      },
    },
  },
}
