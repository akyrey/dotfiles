local cmd = vim.api.nvim_command
local fn = vim.fn
local packer = nil

local function packer_verify()
  vim.cmd("packadd packer.nvim")
  local present, _ = pcall(require, "packer")
  if not present then
    local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

    print("Cloning packer..")
    -- remove the dir before cloning
    vim.fn.delete(packer_path, "rf")
    vim.fn.system(
      {
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        "--depth",
        "20",
        packer_path
      }
    )

    vim.cmd("packadd packer.nvim")
    present, _ = pcall(require, "packer")

    if present then
      print("Packer cloned successfully.")
    else
      error("Couldn't clone packer !\nPacker path: " .. packer_path)
    end
  else
    print("Packer already installed")
  end
end

local function packer_startup()
  if packer == nil then
    _, packer = pcall(require, "packer")
    if packer == nil then
      error("Packer not installed")
      return false
    end
    packer.init()
  end

  local use = packer.use
  packer.reset()

  -- Packer can manage itself
  use {
    'wbthomason/packer.nvim',
    event = 'VimEnter',
  }
  -- Install Material color theme
  use {
    'kaicataldo/material.vim',
    branch = 'main',
    after = 'packer.nvim',
    config = function ()
      require'akyrey.plugins.material'.init()
    end
  }
  -- Color highlighter
  use {
    'norcalli/nvim-colorizer.lua',
    after = 'material.vim',
    config = function ()
      require'akyrey.plugins.colorizer'.init()
    end
  }
  -- Statusline configuration
  use {
    'hoob3rt/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
    after = 'material.vim',
    config = function ()
      require'akyrey.plugins.lualine'.init()
    end
  }
  use {
    'akinsho/nvim-bufferline.lua',
    after = 'material.vim',
    config = function()
      require 'akyrey.plugins.bufferline'.init()
    end
  }
  -- Tree directory structure
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
    cmd = 'NvimTreeToggle',
    config = function()
      require 'akyrey.plugins.nvimtree'.init()
    end
  }
  -- Provides common configuration for various lsp servers
  use {
    'kabouzeid/nvim-lspinstall',
  }
  use {
    'neovim/nvim-lspconfig',
    requires = {
      -- Tree like structure to display symbols in file based on lsp
      'simrat39/symbols-outline.nvim'
    },
    config = function ()
      require'akyrey.plugins.lspconfig'
    end
  }
  use {
    'glepnir/lspsaga.nvim',
    after = 'nvim-lspconfig',
  }
  -- Parser generator and parsing library
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    event = 'BufRead',
    config = function ()
      require'akyrey.plugins.treesitter'.init()
    end
  }
  use {
    'romgrk/nvim-treesitter-context',
    requires = 'nvim-treesitter/nvim-treesitter',
    event = 'BufRead'
  }
  -- Automatically insert pairs
  use {
    'windwp/nvim-autopairs',
    after = 'nvim-compe',
    config = function ()
      require'akyrey.plugins.autopairs'.init()
    end
  }
  -- Comment multiple lines
  use 'tpope/vim-commentary'
  -- Highlight todos
  use {
    'folke/todo-comments.nvim',
    after = 'nvim-treesitter',
    config = function ()
      require'akyrey.plugins.todo-comments'.init()
    end
  }
  -- Auto completion and snippets
  use {
    'hrsh7th/nvim-compe',
    requires = {
      {
        'erkrnt/compe-tabnine',
        run = './install.sh',
      },
      {
        'L3MON4D3/LuaSnip',
        wants = 'friendly-snippets',
        event = 'InsertCharPre',
        config = function()
          require'akyrey.plugins.luasnip'.init()
        end
      },
      {
        'rafamadriz/friendly-snippets',
        event = 'InsertCharPre'
      },
      {
        'onsails/lspkind-nvim',
      }
    },
    event = 'InsertEnter',
    wants = 'LuaSnip',
    config = function ()
      require'akyrey.plugins.compe'.init()
      require'akyrey.plugins.compe_tabnine'.init()
      require'akyrey.plugins.lspkind'.init()
    end
  }
  -- Fuzzy finder over list
  use {
    'nvim-lua/plenary.nvim',
  }
  use {
    'nvim-lua/popup.nvim',
    after = 'plenary.nvim'
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {
        'nvim-lua/popup.nvim',
      },
      {
        'nvim-lua/plenary.nvim',
      },
      {
        'nvim-telescope/telescope-fzy-native.nvim',
      },
      {
        'ThePrimeagen/git-worktree.nvim',
        config = function ()
          require'akyrey.plugins.git-worktree'.init()
        end
      }
    },
    module_pattern = {
      'telescope',
    },
    config = function ()
      require'akyrey.plugins.telescope'.init()
    end
  }
  -- Mark and easily navigate through files
  use {
    'ThePrimeagen/harpoon',
    after = 'popup.nvim',
    module = {
      'harpoon',
    }
  }
  -- Formatter
  use {
    'sbdchd/neoformat',
    event = 'BufRead',
  }
  -- Git management
  use {
    'tpope/vim-fugitive',
    event = 'BufRead',
  }
  use {
    'junegunn/gv.vim',
    after = 'vim-fugitive',
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function ()
      require'akyrey.plugins.gitsigns'.init()
    end
  }
  -- Man page inside vim
  use 'vim-utils/vim-man'
  -- Visualize undo history
  use 'mbbill/undotree'
  -- Metrics, insights and time tracking
  use 'wakatime/vim-wakatime'
  -- Display packages versions available for npm
  use {
    'vuki656/package-info.nvim',
    config = function ()
      require'akyrey.plugins.package-info'.init()
    end
  }
end

local function init()
  packer_verify()
  packer_startup()
  vim.cmd[[autocmd BufWritePost lua/akyrey/packer.lua source <afile>]]
end

return {
  init = init
}
