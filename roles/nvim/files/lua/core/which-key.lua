local M = {}
local Log = require "core.log"

M.config = function()
  akyrey.builtin.which_key = {
    active = true,
    setup = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = false, -- adds help for operators like d, y, ...
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
        spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
      },
      window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
      },
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
    },

    opts = {
      mode = "n", -- NORMAL mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    },
    vopts = {
      mode = "v", -- VISUAL mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    },
    -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
    -- see https://neovim.io/doc/user/map.html#:map-cmd
    -- TODO update mappings with my mappings
    vmappings = {
    },
    mappings = {
      b = {
        name = "Buffers",
        j = { "<cmd>BufferPick<cr>", "jump to buffer" },
        f = { "<cmd>Telescope buffers<cr>", "Find buffer" },
        w = { "<cmd>BufferWipeout<cr>", "wipeout buffer" },
        e = {
          "<cmd>BufferCloseAllButCurrent<cr>",
          "close all but current buffer",
        },
        h = { "<cmd>BufferCloseBuffersLeft<cr>", "close all buffers to the left" },
        l = {
          "<cmd>BufferCloseBuffersRight<cr>",
          "close all BufferLines to the right",
        },
        D = {
          "<cmd>BufferOrderByDirectory<cr>",
          "sort BufferLines automatically by directory",
        },
        L = {
          "<cmd>BufferOrderByLanguage<cr>",
          "sort BufferLines automatically by language",
        },
      },
      p = {
        name = "Packer",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        r = { "<cmd>lua require('utils').reload_lv_config()<cr>", "Reload" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
      },

      -- " Available Debug Adapters:
      -- "   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
      -- " Adapter configuration and installation instructions:
      -- "   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
      -- " Debug Adapter protocol:
      -- "   https://microsoft.github.io/debug-adapter-protocol/
      -- " Debugging
      v = {
        name = "Git",
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
        b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        u = {
          "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
          "Undo Stage Hunk",
        },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        c = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        g = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        C = {
          "<cmd>Telescope git_bcommits<cr>",
          "Checkout commit(for current file)",
        },
      },

      g = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = {
          "<cmd>Telescope lsp_document_diagnostics<cr>",
          "Document Diagnostics",
        },
        w = {
          "<cmd>Telescope lsp_workspace_diagnostics<cr>",
          "Workspace Diagnostics",
        },
        -- f = { "<cmd>silent FormatWrite<cr>", "Format" },
        f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        j = {
          "<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = akyrey.lsp.popup_border}})<cr>",
          "Next Diagnostic",
        },
        k = {
          "<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = akyrey.lsp.popup_border}})<cr>",
          "Prev Diagnostic",
        },
        p = {
          name = "Peek",
          d = { "<cmd>lua require('lsp.peek').Peek('definition')<cr>", "Definition" },
          t = { "<cmd>lua require('lsp.peek').Peek('typeDefinition')<cr>", "Type Definition" },
          i = { "<cmd>lua require('lsp.peek').Peek('implementation')<cr>", "Implementation" },
        },
        q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = {
          "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
          "Workspace Symbols",
        },
      },
      A = {
        name = "+Akyrey",
        c = {
          "<cmd>edit ~/.config/nvim/lua/config.lua<cr>",
          "Edit config.lua",
        },
        f = {
          "<cmd>lua require('core.telescope').find_config_files()<cr>",
          "Find Config files",
        },
        g = {
          "<cmd>lua require('core.telescope').grep_config_files()<cr>",
          "Grep Config files",
        },
        k = { "<cmd>lua require('keymappings').print()<cr>", "View Akyrey's default keymappings" },
        i = {
          "<cmd>lua require('core.info').toggle_popup(vim.bo.filetype)<cr>",
          "Toggle Akyrey Info",
        },
        l = {
          name = "+logs",
          d = {
            "<cmd>lua require('core.terminal').toggle_log_view('akyrey')<cr>",
            "view default log",
          },
          D = { "<cmd>edit ~/.cache/nvim/akyrey.log<cr>", "Open the default logfile" },
          n = { "<cmd>lua require('core.terminal').toggle_log_view('lsp')<cr>", "view lsp log" },
          N = { "<cmd>edit ~/.cache/nvim/log<cr>", "Open the Neovim logfile" },
          l = { "<cmd>lua require('core.terminal').toggle_log_view('nvim')<cr>", "view neovim log" },
          L = { "<cmd>edit ~/.cache/nvim/lsp.log<cr>", "Open the LSP logfile" },
          p = {
            "<cmd>lua require('core.terminal').toggle_log_view('packer.nvim')<cr>",
            "view packer log",
          },
          P = { "<cmd>edit ~/.cache/nvim/packer.nvim.log<cr>", "Open the Packer logfile" },
        },
      },
      T = {
        name = "Treesitter",
        i = { ":TSConfigInfo<cr>", "Info" },
      },
    },
  }
end

M.setup = function()
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    Log:get_default "Failed to load whichkey"
    return
  end

  which_key.setup(akyrey.builtin.which_key.setup)

  local opts = akyrey.builtin.which_key.opts
  local vopts = akyrey.builtin.which_key.vopts

  local mappings = akyrey.builtin.which_key.mappings
  local vmappings = akyrey.builtin.which_key.vmappings

  local wk = require "which-key"

  wk.register(mappings, opts)
  wk.register(vmappings, vopts)
end

return M
