local M = {}
local Log = require "core.log"

M.config = function()
  akyrey.builtin.colorizer = {}
end

M.setup = function()
  local status_ok, colorizer = pcall(require, "colorizer")
  if not status_ok then
    Log:get_default().error "failed to load colorizer"
    return
  end

  colorizer.setup(akyrey.builtin.colorizer)
end

return M
