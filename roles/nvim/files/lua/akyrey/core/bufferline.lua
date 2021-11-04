local M = {}

M.config = function()
  akyrey.builtin.bufferline = {
    active = true,
    on_config_done = nil,
    keymap = {
      normal_mode = {
        ["<S-l>"] = ":BufferNext<CR>",
        ["<S-h>"] = ":BufferPrevious<CR>",
      },
    },
  }
end

M.setup = function()
  local keymap = require "akyrey.keymappings"
  keymap.append_to_defaults(akyrey.builtin.bufferline.keymap)

  if akyrey.builtin.bufferline.on_config_done then
    akyrey.builtin.bufferline.on_config_done()
  end
end

return M