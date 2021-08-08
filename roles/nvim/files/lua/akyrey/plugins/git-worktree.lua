local function init()
  require("git-worktree").setup{ autopush = false }
end

return {
  init = init
}
