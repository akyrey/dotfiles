local M = {}
local Log = require "akyrey.core.log"

M.config = function ()
  akyrey.builtin.git_worktree = {
    active = true,
    on_confirm_done = nil,
    autopush = true,
  }
end

M.setup = function()
  local status_ok, git_worktree = pcall(require, "git-worktree")
  if not status_ok then
    Log:error "Failed to load git_worktree"
    return
  end

  git_worktree.setup(akyrey.builtin.git_worktree)
end

return M
