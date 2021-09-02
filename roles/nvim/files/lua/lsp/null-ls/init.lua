local M = {}

M.list_supported_provider_names = function(filetype)
  local names = {}

  local formatters = require "lsp.null-ls.formatters"
  local linters = require "lsp.null-ls.linters"

  vim.list_extend(names, formatters.list_supported_names(filetype))
  vim.list_extend(names, linters.list_supported_names(filetype))

  return names
end

M.list_unsupported_provider_names = function(filetype)
  local names = {}

  local formatters = require "lsp.null-ls.formatters"
  local linters = require "lsp.null-ls.linters"

  vim.list_extend(names, formatters.list_unsupported_names(filetype))
  vim.list_extend(names, linters.list_unsupported_names(filetype))

  return names
end

-- TODO: for linters and formatters with spaces and '-' replace with '_'
M.setup = function(filetype, options)
  options = options or {}

  local ok, _ = pcall(require, "null-ls")
  if not ok then
    require("core.log"):get_default().error "Missing null-ls dependency"
    return
  end

  local formatters = require "lsp.null-ls.formatters"
  local linters = require "lsp.null-ls.linters"

  formatters.setup(filetype, options)
  linters.setup(filetype, options)
end

return M
