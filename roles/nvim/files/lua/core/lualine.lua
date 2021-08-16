local M = {}
local Log = require "core.log"

M.config = function()
  akyrey.builtin.lualine = {
    options = {
      extensions = { 'fugitive', 'quickfix' },
      theme = 'gruvbox',
    }
  }
end

M.setup = function()
  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
    Log:get_default().error "failed to load lualine"
    return
  end

  lualine.setup(akyrey.builtin.lualine)
end

return M
