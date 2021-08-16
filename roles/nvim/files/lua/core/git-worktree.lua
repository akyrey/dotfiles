local M = {}
local Log = require "core.log"

M.config = function ()
  akyrey.builtin.git_worktree = {
    autopush = true,
  }
end

M.setup = function()
  local status_ok, git_worktree = pcall(require, "git-worktree")
  if not status_ok then
    Log:get_default().error "Failed to load git-worktree"
    return
  end

  git_worktree.setup(akyrey.builtin.git_worktree)
end

return M
