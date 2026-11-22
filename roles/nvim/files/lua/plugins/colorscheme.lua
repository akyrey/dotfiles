return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000, -- load before anything that reads highlight groups
    opts = {
      flavour = "macchiato",
      background = { light = "latte", dark = "macchiato" },
      -- Integrations are listed explicitly below. Auto-detection calls
      -- vim.pack.get(), which creates an empty site/pack/core/opt on every
      -- start and makes lazy.nvim's health check warn about another plugin
      -- manager.
      auto_integrations = false,
      integrations = {
        blink_cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        flash = true,
        gitsigns = true,
        grug_far = true,
        harpoon = true,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = { enabled = true, inlay_hints = { background = true } },
        neotest = true,
        noice = true,
        overseer = true,
        rainbow_delimiters = true,
        render_markdown = true,
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
