return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "plenary.nvim",
    },
    event = "BufRead",
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    event = "VeryLazy",
  },
}
