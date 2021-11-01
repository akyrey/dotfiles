akyrey.builtin.terminal.active = true
akyrey.builtin.nvimtree.setup.view.side = "left"
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
    filetypes = { "css", "html", "javascript", "javascriptreact", "json", "scss", "tailwindcss", "typescript", "typescriptreact" },
  },
}
