akyrey.builtin.terminal.active = true
akyrey.builtin.treesitter.ensure_installed = {
  'bash',
  'css',
  'dockerfile',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'scss',
  'tsx',
  'typescript',
  'yaml',
}

local formatters = require "akyrey.lsp.null-ls.formatters"
formatters.setup {
  {
    exe = "prettierd",
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "css", "html", "javascript", "javascriptreact", "json", "scss", "tailwindcss", "typescript", "typescriptreact" },
  },
}

-- set additional linters
local linters = require "akyrey.lsp.null-ls.linters"
linters.setup {
  {
    exe = "eslint_d",
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
}

-- Load angularls if we are in an Angular project
if require("akyrey.utils").is_in_package_json("@angular/core") == true then
  require("akyrey.lsp.manager").setup "angularls"
end

-- Load tailwindcss if we are in a project with tailwindcss installed
if require("akyrey.utils").is_in_package_json("tailwindcss") == true then
  require("akyrey.lsp.manager").setup "tailwindcss"
end
