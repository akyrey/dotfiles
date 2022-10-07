return {
  -- Packer can manage itself
  { "wbthomason/packer.nvim" },
  -- LSP
  { "neovim/nvim-lspconfig" },
  { "tamago324/nlsp-settings.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "antoinemadec/FixCursorHold.nvim" }, -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  { "williamboman/nvim-lsp-installer" },
  { "rcarriga/nvim-notify" },
  { "Tastyep/structlog.nvim" },


  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("akyrey.core.telescope").setup()
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
  },
  -- Mark and easily navigate through files
  { "ThePrimeagen/harpoon" },

  -- Movement
  {
    "ggandor/lightspeed.nvim",
    config = function ()
      require("akyrey.core.lightspeed").setup()
    end,
    requires = {
      "tpope/vim-repeat"
    },
  },

  -- Completions & Snippets
  -- Auto completion and snippets
  {
    "hrsh7th/nvim-cmp",
    config = function ()
      require("akyrey.core.cmp").setup()
    end,
    requires = {
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lua" },
      { "f3fora/cmp-spell" },
      {
        "tzachar/cmp-tabnine",
        run = "./install.sh",
      },
      { "David-Kunz/cmp-npm" },
    },
    run = function()
      -- cmp's config requires cmp to be installed to run the first time
      if not akyrey.builtin.cmp then
        require("akyrey.core.cmp").config()
      end
    end,
  },
  { "onsails/lspkind-nvim" },
  {
    "rafamadriz/friendly-snippets",
    event = "InsertCharPre"
  },
  -- Automatically insert pairs
  {
    "windwp/nvim-autopairs",
    config = function ()
      require("akyrey.core.autopairs").setup()
    end
  },

  {
    "simrat39/rust-tools.nvim",
    config = function ()
      require('rust-tools').setup({})
    end
  },

  -- Parser generator and parsing library
  {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      { "windwp/nvim-ts-autotag" },
    },
    run = ":TSUpdate",
    config = function ()
      require("akyrey.core.treesitter").setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function ()
      require("akyrey.core.treesitter-context").setup()
    end,
    disable = not akyrey.builtin.treesitter_context.active,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    event = "BufRead",
    config = function ()
      require("akyrey.core.refactoring").setup()
    end
  },

  -- Git related
  { "tpope/vim-fugitive" },
  {
    "TimUntersberger/neogit",
    requires = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = function ()
      require("akyrey.core.neogit").setup()
    end
  },
  {
    "sindrets/diffview.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function ()
      require("akyrey.core.gitsigns").setup()
    end
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function ()
      require("akyrey.core.git-worktree").setup()
    end
  },

  -- Install Gruvbox color theme
  -- { "morhetz/gruvbox" },
  -- Install Tokyo Night theme
  -- { "folke/tokyonight.nvim" },
  {
    "catppuccin/nvim",
    as = 'catppuccin',
    config = function ()
      local ok, catppuccin = pcall(require, "catppuccin")
      if not ok then return end

      vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
      catppuccin.setup {}
    end
  },
  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    config = function ()
      require("akyrey.core.colorizer").setup()
    end
  },
  -- Statusline configuration
  {
    "nvim-lualine/lualine.nvim",
    config = function ()
      require("akyrey.core.lualine").setup()
    end
  },

  -- Icons
  { "kyazdani42/nvim-web-devicons" },

  -- Display undo history as a tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
    config = function()
      require("akyrey.core.package-info").setup()
    end,
  },
  -- Comment multiple lines
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    config = function()
      require("akyrey.core.comment").setup()
    end,
  },
  -- Highlight todos
  {
    "folke/todo-comments.nvim",
    config = function ()
      require("akyrey.core.todo-comments").setup()
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  -- Whichkey
  {
    "folke/which-key.nvim",
    config = function()
      require("akyrey.core.which-key").setup()
    end,
    event = "BufWinEnter",
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    -- event = "BufWinEnter",
    config = function()
      require("akyrey.core.dap").setup()
    end,
    disable = not akyrey.builtin.dap.active,
  },
  {
    "rcarriga/nvim-dap-ui",
    requires = {
      { "mfussenegger/nvim-dap" },
    },
  },
  -- Debugger management
  {
    "Pocco81/dap-buddy.nvim",
    branch = "dev",
    -- event = "BufWinEnter",
    -- event = "BufRead",
    disable = not akyrey.builtin.dap.active,
  },

  -- Database
  {
    "kristijanhusak/vim-dadbod-ui",
    requires = {
      { "tpope/vim-dadbod" },
    }
  },


  -- Terminal
  {
    "akinsho/nvim-toggleterm.lua",
    event = "BufWinEnter",
    config = function()
      require("akyrey.core.terminal").setup()
    end,
    disable = not akyrey.builtin.terminal.active,
  },

  -- Metrics, insights and time tracking
  {
    'wakatime/vim-wakatime',
  }
}
