-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}

function M.setup()
  local config = { -- your config
    virtual_text = akyrey.lsp.diagnostics.virtual_text,
    signs = akyrey.lsp.diagnostics.signs,
    underline = akyrey.lsp.diagnostics.underline,
    update_in_insert = akyrey.lsp.diagnostics.update_in_insert,
    severity_sort = akyrey.lsp.diagnostics.severity_sort,
    float = akyrey.lsp.diagnostics.float,
  }
  vim.diagnostic.config(config)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, akyrey.lsp.float)
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, akyrey.lsp.float)
end

function M.show_line_diagnostics()
  local config = akyrey.lsp.diagnostics.float
  config.scope = "line"
  return vim.diagnostic.open_float(0, config)
end

return M
