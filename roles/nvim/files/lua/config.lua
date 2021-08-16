CONFIG_PATH = os.getenv "HOME" .. "/.local/share/nvim"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
TERMINAL = vim.fn.expand "$TERMINAL"
USER = vim.fn.expand "$USER"

akyrey = {
  leader = " ",
  line_wrap_cursor_movement = true,
  transparent_window = true,
  format_on_save = false,
  vsnip_dir = os.getenv "HOME" .. "/.config/snippets",
  database = { save_location = "~/.config/nvim_db", auto_execute = 1 },
  keys = {
    -- use keymappings.lua for these
  },

  -- These aren't probably required, but an initialization doesn't hurt
  builtin = {
    autopairs = {},
    bufferline = {},
    colorizer = {},
    compe = {},
    dap = {},
    git_worktree = {},
    gitsigns = {},
    lspinstall = {},
    lualine = {},
    nvimtree = {},
    rooter = {},
    telescope = {},
    terminal = {},
    todo_comments = {},
    treesitter = {},
    which_key = {},
  },

  log = {
    ---@usage can be { "trace", "debug", "info", "warn", "error", "fatal" },
    level = "info",
    viewer = {
      ---@usage this will fallback on "less +F" if not found
      cmd = "lnav",
      layout_config = {
        ---@usage direction = 'vertical' | 'horizontal' | 'window' | 'float',
        direction = "horizontal",
        open_mapping = "",
        size = 40,
        float_opts = {},
      },
    },
  },

  lsp = {
    completion = {
      item_kind = {
        "   (Text) ",
        "   (Method)",
        "   (Function)",
        "   (Constructor)",
        " ﴲ  (Field)",
        "[] (Variable)",
        "   (Class)",
        " ﰮ  (Interface)",
        "   (Module)",
        " 襁 (Property)",
        "   (Unit)",
        "   (Value)",
        " 練 (Enum)",
        "   (Keyword)",
        "   (Snippet)",
        "   (Color)",
        "   (File)",
        "   (Reference)",
        "   (Folder)",
        "   (EnumMember)",
        " ﲀ  (Constant)",
        " ﳤ  (Struct)",
        "   (Event)",
        "   (Operator)",
        "   (TypeParameter)",
      },
    },
    diagnostics = {
      signs = {
        active = true,
        values = {
          { name = "LspDiagnosticsSignError", text = "" },
          { name = "LspDiagnosticsSignWarning", text = "" },
          { name = "LspDiagnosticsSignHint", text = "" },
          { name = "LspDiagnosticsSignInformation", text = "" },
        },
      },
      virtual_text = {
        prefix = "",
        spacing = 0,
      },
      underline = true,
      severity_sort = true,
    },
    override = {},
    document_highlight = true,
    popup_border = "single",
    on_attach_callback = nil,
    on_init_callback = nil,
    ---@usage query the project directory from the language server and use it to set the CWD
    smart_cwd = true,
  },

  plugins = {
    -- use plugins.lua for these
  },

  autocommands = {
    -- use core/autocommands.lua for these
  },
}

require "config-lang"
require("keymappings").config()
require("core.which-key").config()
require "core.status_colors"
require("core.gitsigns").config()
require("core.compe").config()
require("core.colorizer").config()
require("core.git-worktree").config()
require("core.lualine").config()
require("core.todo-comments").config()
require("core.dap").config()
require("core.terminal").config()
require("core.telescope").config()
require("core.treesitter").config()
require("core.nvimtree").config()
require("core.rooter").config()
require("core.bufferline").config()
