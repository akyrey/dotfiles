return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = function(_, opts)
      opts.flavour = "macchiato"
      opts.transparent_background = true

      -- Color line numbers
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#2196f3" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FBC02D" })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
