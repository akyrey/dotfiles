local M = {}

local builtins = {
  "akyrey.keymappings",
  "akyrey.core.autopairs",
  "akyrey.core.cmp",
  "akyrey.core.colorizer",
  "akyrey.core.dap",
  "akyrey.core.git-worktree",
  "akyrey.core.gitsigns",
  "akyrey.core.lualine",
  "akyrey.core.lightspeed",
  "akyrey.core.neogit",
  "akyrey.core.notify",
  "akyrey.core.package-info",
  "akyrey.core.refactoring",
  "akyrey.core.telescope",
  "akyrey.core.terminal",
  "akyrey.core.todo-comments",
  "akyrey.core.treesitter",
  "akyrey.core.treesitter-context",
  "akyrey.core.which-key",
  "akyrey.core.comment",
}

function M.config(config)
  for _, builtin_path in ipairs(builtins) do
    local builtin = require(builtin_path)
    builtin.config(config)
  end
end

return M

