-- Format-on-save control, replacing LazyVim's util.format.
--
-- Autoformat is OFF globally (`vim.g.autoformat = false` in core/options.lua).
-- `vim.b.autoformat` overrides it per buffer, so you can opt a single buffer in
-- or out. conform.nvim asks `M.enabled()` on every save.
local M = {}

---@param buf? integer
---@return boolean
function M.enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- a buffer-local setting always wins
  if baf ~= nil then
    return baf
  end
  return gaf == nil or gaf
end

---@param opts? { buf?: integer, global?: boolean }
function M.toggle(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local enable = not M.enabled(buf)

  if opts.global then
    vim.g.autoformat = enable
    vim.b[buf].autoformat = nil
  else
    vim.b[buf].autoformat = enable
  end
  M.info(opts)
end

---@param opts? { buf?: integer, global?: boolean }
function M.info(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local scope = opts.global and "globally" or "for this buffer"
  local state = M.enabled(buf) and "enabled" or "disabled"
  vim.notify(("Autoformat **%s** %s"):format(state, scope), vim.log.levels.INFO, { title = "Format" })
end

--- Format the buffer with conform, bypassing the autoformat setting.
---@param opts? { buf?: integer }
function M.format(opts)
  opts = opts or {}
  require("conform").format(vim.tbl_extend("force", { async = false, lsp_format = "fallback" }, opts))
end

return M
