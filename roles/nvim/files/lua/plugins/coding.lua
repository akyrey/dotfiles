return {
  -- Completion engine.
  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    version = "1.*", -- release tags ship prebuilt fuzzy-matcher binaries
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "saghen/blink.compat",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = "luasnip" },
      keymap = {
        preset = "enter",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = { "\u{256d}", "\u{2500}", "\u{256e}", "\u{2502}", "\u{256f}", "\u{2500}", "\u{2570}", "\u{2502}" },
          draw = {
            treesitter = { "lsp" },
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = { "\u{256d}", "\u{2500}", "\u{256e}", "\u{2502}", "\u{256f}", "\u{2500}", "\u{2570}", "\u{2502}" },
          },
        },
        ghost_text = { enabled = false },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },

  -- Compatibility shim so nvim-cmp sources can be used from blink.
  {
    "saghen/blink.compat",
    version = "2.*", -- v2 pairs with blink.cmp v1
    lazy = true,
    opts = {},
  },

  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (not jit.os:find("Windows")) and "make install_jsregexp" or nil,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = { history = true, delete_check_events = "TextChanged" },
  },

  -- Snippet collection. Loading the vscode-format snippets costs ~10ms, so it
  -- waits until the first insert rather than running at startup (blink pulls
  -- LuaSnip in early to register LSP capabilities).
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
    init = function()
      vim.api.nvim_create_autocmd("InsertEnter", {
        once = true,
        callback = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      })
    end,
  },

  -- Smarter a/i textobjects: aa/ia for arguments, af/if for functions, ...
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
  },

  -- Auto-close brackets and quotes.
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },

  -- sa/sd/sr to add, delete and replace surrounding pairs.
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      -- Prefixed with `gs` so plain `s` keeps its built-in meaning and stays
      -- free for flash.nvim.
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
      },
    },
    keys = {
      -- mini.surround has no mapping option for this one, so bind it directly.
      {
        "gsn",
        function()
          require("mini.surround").update_n_lines()
        end,
        desc = "Update MiniSurround.config.n_lines",
      },
    },
  },

  -- Yank history, so an overwritten register is recoverable.
  {
    "gbprod/yanky.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { timer = 150 },
    },
    -- stylua: ignore
    keys = {
      { "<leader>p", function() Snacks.picker.yanky() end, mode = { "n", "x" }, desc = "Open yank history" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before cursor" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      -- Put and re-indent to the current line, and linewise put above/below.
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after and leave cursor after" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before and leave cursor after" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before (linewise)" },
    },
  },

  -- Rename/close HTML and JSX tags as you type.
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
