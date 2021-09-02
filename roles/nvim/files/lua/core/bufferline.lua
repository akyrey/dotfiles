local M = {}

M.config = function()
  akyrey.builtin.bufferline = {
    active = true,
    keymap = {
      normal_mode = {
        ["<S-l>"] = ":BufferNext<CR>",
        ["<S-h>"] = ":BufferPrevious<CR>",
      },
    },
  }
end

M.setup = function()
  local keymap = require "keymappings"
  keymap.append_to_defaults(akyrey.builtin.bufferline.keymap)
end

return M
