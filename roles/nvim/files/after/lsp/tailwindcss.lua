-- Overrides on top of nvim-lspconfig's lsp/tailwindcss.lua.
--
-- lspconfig falls back to `.git` as a root marker so tailwind v4 projects
-- (which have no tailwind.config.*) still get a server, but that also starts it
-- in every git repository with a PHP or HTML file. Instead, root on a tailwind
-- or postcss config, or on a package.json that mentions tailwindcss (true for
-- v4's @tailwindcss/vite and @tailwindcss/postcss as well).
local CONFIG_FILES = {
  "tailwind.config.js",
  "tailwind.config.cjs",
  "tailwind.config.mjs",
  "tailwind.config.ts",
  "postcss.config.js",
  "postcss.config.cjs",
  "postcss.config.mjs",
  "postcss.config.ts",
}

return {
  filetypes = { "blade", "css", "html", "javascriptreact", "less", "php", "sass", "scss", "typescriptreact", "vue" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local markers = require("lspconfig.util").insert_package_json(vim.deepcopy(CONFIG_FILES), "tailwindcss", fname)
    local found = vim.fs.find(markers, { path = fname, upward = true })[1]
    if found then
      on_dir(vim.fs.dirname(found))
    end
  end,
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
