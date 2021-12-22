local M = {}

local Log = require "akyrey.core.log"

function M:setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    Log:error "Missing null-ls dependency"
    return
  end

  local default_opts = require("akyrey.lsp").get_common_opts()

  if vim.tbl_isempty(akyrey.lsp.null_ls.setup or {}) then
    akyrey.lsp.null_ls.setup = default_opts
  end

  null_ls.setup(akyrey.lsp.null_ls.setup)
end

return M
