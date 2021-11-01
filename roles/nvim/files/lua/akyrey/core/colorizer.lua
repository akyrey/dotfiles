local M = {}
local Log = require "akyrey.core.log"

M.config = function()
  akyrey.builtin.colorizer = {
    active = true,
    on_confirm_done = nil,
  }
end

M.setup = function()
  local status_ok, colorizer = pcall(require, "colorizer")
  if not status_ok then
    Log:error "Failed to load colorizer"
    return
  end

  colorizer.setup(akyrey.builtin.colorizer)
end

return M
