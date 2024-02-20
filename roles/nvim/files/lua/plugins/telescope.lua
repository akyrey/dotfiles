return {
  "telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "ThePrimeagen/refactoring.nvim",
      config = function()
        require("telescope").load_extension("refactoring")
      end,
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("telescope").load_extension("git_worktree")
    end,
  },
}
