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
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        ignore_whitespace = true,
      },
    },
  },
}
