return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000, -- load before anything that reads highlight groups
    opts = {
      flavour = "macchiato",
      background = { light = "latte", dark = "macchiato" },
      integrations = {
        blink_cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        markdown = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = { enabled = true, inlay_hints = { background = true } },
        neotest = true,
        noice = true,
        overseer = true,
        rainbow_delimiters = true,
        snacks = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
