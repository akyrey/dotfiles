local M = {}

local builtins = {
  "akyrey.keymappings",
  "akyrey.core.autopairs",
  "akyrey.core.bufferline",
  "akyrey.core.cmp",
  "akyrey.core.dap",
  "akyrey.core.gitsigns",
  "akyrey.core.lualine",
  "akyrey.core.nvimtree",
  "akyrey.core.notify",
  "akyrey.core.telescope",
  "akyrey.core.terminal",
  "akyrey.core.treesitter",
  "akyrey.core.which-key",
}

function M.config(config)
  for _, builtin_path in ipairs(builtins) do
    local builtin = require(builtin_path)
    builtin.config(config)
  end
end

return M

