local M = {}
M.config = function()
  akyrey.builtin.lualine = {
    active = true,
    style = "akyrey",
    options = {
      icons_enabled = nil,
      component_separators = nil,
      section_separators = nil,
      theme = akyrey.colorscheme,
      disabled_filetypes = nil,
    },
    sections = {
      lualine_a = nil,
      lualine_b = nil,
      lualine_c = nil,
      lualine_x = nil,
      lualine_y = nil,
      lualine_z = nil,
    },
    inactive_sections = {
      lualine_a = nil,
      lualine_b = nil,
      lualine_c = nil,
      lualine_x = nil,
      lualine_y = nil,
      lualine_z = nil,
    },
    tabline = nil,
    extensions = nil,
    on_config_done = nil,
  }
end

M.setup = function()
  require("akyrey.core.lualine.styles").update()
  require("akyrey.core.lualine.utils").validate_theme()

  local lualine = require "lualine"
  lualine.setup(akyrey.builtin.lualine)

  if akyrey.builtin.lualine.on_config_done then
    akyrey.builtin.lualine.on_config_done(lualine)
  end
end

return M
