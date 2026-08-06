return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      dashboard = { enabled = false },
      scroll = { enabled = false },

      ---@class snacks.explorer.Config
      explorer = {},
      picker = {
        sources = {
          ---@class snacks.picker.explorer.Config
          explorer = {
            auto_close = true,
            matcher = { sort_empty = false, fuzzy = true },
            layout = {
              preset = "telescope",
              border = true,
              reverse = false,
              preview = false,
            },
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- sources = {
    --   default = { "lsp", "path", "snippets", "buffer", "laravel" },
    --   providers = {
    --     laravel = {
    --       name = "laravel",
    --       module = "blink.compat.source",
    --       score_offset = 95,
    --     },
    --   },
    -- },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        menu = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          },
        },
        documentation = {
          window = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          },
        },
      },
    },
  },
  {
    "saghen/blink.compat",
    -- use v2.* for blink.cmp v1.*
    version = "2.*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "rafamadriz/friendly-snippets",
    -- add blink.compat to dependencies
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
  },
}
