local M = {}

M.config = function()
  akyrey.builtin.which_key = {
    ---@usage disable which-key completely [not recommeded]
    active = true,
    on_config_done = nil,
    setup = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
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
    vmappings = {
    },
    mappings = {
      b = {
        name = "Buffers",
        b = { "<cmd>b#<cr>", "Previous" },
        e = {
          "<cmd>BufferCloseAllButCurrent<cr>",
          "Close all but current",
        },
        -- Lists open buffers in current neovim instance
        f = { "<cmd>Telescope buffers<cr>", "Find" },
      },

      d = {
        name = "Debug",
        t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
        b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
        d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
        g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
        u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
        p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
        s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
        q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
      },

      v = {
        name = "Git",
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
        l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        u = {
          "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
          "Undo Stage Hunk",
        },
        -- Telescope related
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        C = {
          "<cmd>Telescope git_bcommits<cr>",
          "Checkout commit(for current file)",
        },
        d = {
          "<cmd>Gitsigns diffthis HEAD<cr>",
          "Git Diff",
        },
        -- ------------------- --
        --       Neogit        --
        -- ------------------- --
        G = { "<CMD>lua require('neogit').open({ kind = 'split' })<CR>", "Neogit" },
        g = { "<CMD>diffget //2<CR>", "Get left chunk" },
        h = { "<CMD>diffget //3<CR>", "Get right chunk" },
        -- ------------------- --
        --    Git Worktree     --
        -- ------------------- --
        w = {
          name = "+Worktree",
          l = {
            "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
            "List worktrees"
          },
          c = {
            "<CMD>lua require('git-worktree').create_worktree(vim.fn.input('Worktree name > '), vim.fn.input('Worktree upstream > '))<CR>",
            "Create worktree"
          },
          s = {
            "<CMD>lua require('git-worktree').switch_worktree(vim.fn.input('Worktree name > '))<CR>",
            "Switch worktree"
          },
          d = {
            "<CMD>lua require('git-worktree').delete_worktree(vim.fn.input('Worktree name > '))<CR>",
            "Delete worktree"
          },
        }
      },

      l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = {
          "<cmd>Telescope diagnostics bufnr=0<cr>",
          "Document Diagnostics",
        },
        w = {
          "<cmd>Telescope diagnostics<cr>",
          "Workspace Diagnostics",
        },
        f = { require("akyrey.lsp.utils").format, "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
        j = {
          "<cmd>lua vim.diagnostic.goto_next({popup_opts = {border = akyrey.lsp.popup_border}})<cr>",
          "Next Diagnostic",
        },
        k = {
          "<cmd>lua vim.diagnostic.goto_prev({popup_opts = {border = akyrey.lsp.popup_border}})<cr>",
          "Prev Diagnostic",
        },
        l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        p = {
          name = "Peek",
          d = { "<cmd>lua require('akyrey.lsp.peek').Peek('definition')<cr>", "Definition" },
          t = { "<cmd>lua require('akyrey.lsp.peek').Peek('typeDefinition')<cr>", "Type Definition" },
          i = { "<cmd>lua require('akyrey.lsp.peek').Peek('implementation')<cr>", "Implementation" },
        },
        q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
        r = { "<CMD>lua require('akyrey.core.refactoring').refactors()<CR>", "Refactors" },
        c = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = {
          "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
          "Workspace Symbols",
        },
      },

      A = {
        name = "+Akyrey",
        c = {
          "<cmd>edit " .. get_config_dir() .. "/akyrey.config.lua<cr>",
          "Edit config.lua",
        },
        f = {
          "<cmd>lua require('akyrey.core.telescope.custom-finders').find_config_files()<cr>",
          "Find config files",
        },
        g = {
          "<cmd>lua require('akyrey.core.telescope.custom-finders').grep_config_files()<cr>",
          "Grep config files",
        },
        k = { "<cmd>lua require('akyrey.keymappings').print()<cr>", "View Akyrey's default keymappings" },
        l = {
          name = "+logs",
          d = {
            "<cmd>lua require('akyrey.core.terminal').toggle_log_view(require('akyrey.core.log').get_path())<cr>",
            "view default log",
          },
          D = {
            "<cmd>lua vim.fn.execute('edit ' .. require('akyrey.core.log').get_path())<cr>",
            "Open the default logfile",
          },
          l = { "<cmd>lua require('akyrey.core.terminal').toggle_log_view(vim.lsp.get_log_path())<cr>", "view lsp log" },
          L = { "<cmd>lua vim.fn.execute('edit ' .. vim.lsp.get_log_path())<cr>", "Open the LSP logfile" },
          n = {
            "<cmd>lua require('akyrey.core.terminal').toggle_log_view(os.getenv('NVIM_LOG_FILE'))<cr>",
            "view neovim log",
          },
          N = { "<cmd>edit $NVIM_LOG_FILE<cr>", "Open the Neovim logfile" },
          p = {
            "<cmd>lua require('akyrey.core.terminal').toggle_log_view('packer.nvim')<cr>",
            "view packer log",
          },
          P = { "<cmd>exe 'edit '.stdpath('cache').'/packer.nvim.log'<cr>", "Open the Packer logfile" },
        },
        r = { "<cmd>lua require('akyrey.config.init').reload()<cr>", "Reload Akyrey's configuration" },
      },

      -- ------------------- --
      --      Telescope      --
      -- ------------------- --
      s = {
        name = "Search",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        -- Lists files in your current working directory, respects .gitignore
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        -- Lists available help tags and opens a new window with the relevant help info on <cr>
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        t = { "<cmd>Telescope live_grep<cr>", "Text" },
        -- Searches all project by a string
        s = {
          "<CMD>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ')})<CR>",
          "Search by string",
        },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
        p = {
          "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
          "Colorscheme with Preview",
        },
        T = { "<CMD>lua require('telescope.builtin').treesitter()<CR>", "Treesitter symbols" },
        -- Searches for the string under your cursor in your current working directory
        w = {
          "<CMD>lua require('telescope.builtin').grep_string { search = vim.fn.expand('<cword>') }<CR>",
          "Search string under your cursor",
        },
      },

      -- ------------------- --
      --        Harpoon      --
      -- ------------------- --
      h = {
        name = "+Harpoon",
        a = { "<CMD>lua require('harpoon.mark').add_file()<CR>", "Add file" },
        t = { "<CMD>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Toggle quick menu" },
        h = { "<CMD>lua require('harpoon.ui').nav_file(1)<CR>", "Navigate to #1" },
        j = { "<CMD>lua require('harpoon.ui').nav_file(2)<CR>", "Navigate to #2" },
        k = { "<CMD>lua require('harpoon.ui').nav_file(3)<CR>", "Navigate to #3" },
        l = { "<CMD>lua require('harpoon.ui').nav_file(4)<CR>", "Navigate to #4" },
      },

      -- ------------------- --
      --      Navigation     --
      -- ------------------- --
      n = {
        name = "+Navigation",
        -- Go to next occurence in local quickfix list
        k = { "<CMD>lua require('akyrey.utils').navigate_QF(false)<CR>zz", "Next QF list" },
        -- Go to previous occurence in local quickfix list
        j = { "<CMD>lua require('akyrey.utils').navigate_QF(true)<CR>zz", "Prev QF list" },
        -- Open global quickfix list
        q = { "<CMD>lua require('akyrey.utils').toggle_global_or_local_QF()<CR>", "Toggle global or local QF list" },
        -- Open local quickfix list
        t = { "<CMD>lua require('akyrey.utils').toggle_QF()<CR>", "Toggle QF list" },
      },

      T = {
        name = "Treesitter",
        i = { ":TSConfigInfo<cr>", "Info" },
      },
    },
  }
end

M.setup = function()
  local which_key = require "which-key"

  which_key.setup(akyrey.builtin.which_key.setup)

  local opts = akyrey.builtin.which_key.opts
  local vopts = akyrey.builtin.which_key.vopts

  local mappings = akyrey.builtin.which_key.mappings
  local vmappings = akyrey.builtin.which_key.vmappings

  which_key.register(mappings, opts)
  which_key.register(vmappings, vopts)

  if akyrey.builtin.which_key.on_config_done then
    akyrey.builtin.which_key.on_config_done(which_key)
  end
end

return M
