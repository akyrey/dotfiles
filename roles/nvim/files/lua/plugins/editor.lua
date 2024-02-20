return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.close_if_last_window = true
      opts.window.position = "float"
      opts.window.width = nil
    end,
  },
}
