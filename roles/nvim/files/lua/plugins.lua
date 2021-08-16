return {
  -- Packer can manage itself
  { "wbthomason/packer.nvim" },
  -- LSP
  { "neovim/nvim-lspconfig" },
  { "tamago324/nlsp-settings.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  {
    "kabouzeid/nvim-lspinstall",
    event = "VimEnter",
    config = function()
      local lspinstall = require "lspinstall"
      lspinstall.setup()
      if akyrey.builtin.lspinstall.on_config_done then
        akyrey.builtin.lspinstall.on_config_done(lspinstall)
      end
    end,
  },

  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    config = function()
      require("core.telescope").setup()
      if akyrey.builtin.telescope.on_config_done then
        akyrey.builtin.telescope.on_config_done(require "telescope")
      end
    end,
  },
  -- Mark and easily navigate through files
  { "ThePrimeagen/harpoon" },

  -- Completions & Snippets
  -- Auto completion and snippets
  {
    "hrsh7th/nvim-compe",
    event = "InsertEnter",
    config = function ()
      require("core.compe").setup()
      if akyrey.builtin.compe.on_config_done then
        akyrey.builtin.compe.on_config_done(require "compe")
      end
    end
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
  },
  {
    "rafamadriz/friendly-snippets",
    event = "InsertCharPre"
  },
  -- Automatically insert pairs
  {
    "windwp/nvim-autopairs",
    after = "nvim-compe",
    config = function ()
      require "core.autopairs"
      if akyrey.builtin.autopairs.on_config_done then
        akyrey.builtin.autopairs.on_config_done(require "nvim-autopairs")
      end
    end
  },

  -- Parser generator and parsing library
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "0.5-compat",
    run = ":TSUpdate",
    config = function ()
      require("core.treesitter").setup()
      if akyrey.builtin.treesitter.on_config_done then
        akyrey.builtin.treesitter.on_config_done(require "nvim-treesitter.configs")
      end
    end
  },
  { "romgrk/nvim-treesitter-context" },

  -- Git related
  { "tpope/vim-fugitive" },
  { "junegunn/gv.vim" },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function ()
      require("core.gitsigns").setup()
      if akyrey.builtin.gitsigns.on_config_done then
        akyrey.builtin.gitsigns.on_config_done(require "gitsigns")
      end
    end
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function ()
      require("core.git-worktree").setup()
      if akyrey.builtin.git_worktree.on_config_done then
        akyrey.builtin.git_worktree.on_config_done(require "git-worktree")
      end
    end
  },

  -- Install Material color theme
  { "marko-cerovac/material.nvim" },
  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function ()
      require("core.colorizer").setup()
      if akyrey.builtin.colorizer.on_config_done then
        akyrey.builtin.colorizer.on_config_done(require "colorizer")
      end
    end
  },
  -- Statusline configuration
  {
    "hoob3rt/lualine.nvim",
    config = function ()
      require("core.lualine").setup()
      if akyrey.builtin.lualine.on_config_done then
        akyrey.builtin.lualine.on_config_done(require "lualine")
      end
    end
  },
  -- Bufferline
  {
    "romgrk/barbar.nvim",
    config = function()
      require("core.bufferline").setup()
      if akyrey.builtin.bufferline.on_config_done then
        akyrey.builtin.bufferline.on_config_done()
      end
    end,
    event = "BufWinEnter",
    disable = not akyrey.builtin.bufferline.active,
  },

  -- Icons
  { "kyazdani42/nvim-web-devicons" },

  -- NvimTree
  {
    "kyazdani42/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    config = function()
      require("core.nvimtree").setup()
      if akyrey.builtin.nvimtree.on_config_done then
        akyrey.builtin.nvimtree.on_config_done(require "nvim-tree.config")
      end
    end,
  },
  -- Display undo history as a tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  -- Comment multiple lines
  {
    "tpope/vim-commentary",
    event = "BufRead",
  },
  -- Highlight todos
  {
    "folke/todo-comments.nvim",
    config = function ()
      require("core.todo-comments").setup()
      if akyrey.builtin.todo_comments.on_config_done then
        akyrey.builtin.todo_comments.on_config_done(require "todo-comments")
      end
    end
  },
  -- Whichkey
  {
    "folke/which-key.nvim",
    config = function()
      require("core.which-key").setup()
      if akyrey.builtin.which_key.on_config_done then
        akyrey.builtin.which_key.on_config_done(require "which-key")
      end
    end,
    event = "BufWinEnter",
  },

  -- vim-rooter
  {
    "airblade/vim-rooter",
    -- event = "BufReadPre",
    config = function()
      require("core.rooter").setup()
      if akyrey.builtin.rooter.on_config_done then
        akyrey.builtin.rooter.on_config_done()
      end
    end,
    disable = not akyrey.builtin.rooter.active,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    -- event = "BufWinEnter",
    config = function()
      require("core.dap").setup()
      if akyrey.builtin.dap.on_config_done then
        akyrey.builtin.dap.on_config_done(require "dap")
      end
    end,
    disable = not akyrey.builtin.dap.active,
  },
  -- Debugger management
  {
    "Pocco81/DAPInstall.nvim",
    -- event = "BufWinEnter",
    -- event = "BufRead",
    disable = not akyrey.builtin.dap.active,
  },


  -- Terminal
  {
    "akinsho/nvim-toggleterm.lua",
    event = "BufWinEnter",
    config = function()
      require("core.terminal").setup()
      if akyrey.builtin.terminal.on_config_done then
        akyrey.builtin.terminal.on_config_done(require "toggleterm")
      end
    end,
    disable = not akyrey.builtin.terminal.active,
  },

  -- Metrics, insights and time tracking
  {
    'wakatime/vim-wakatime',
  }
}
