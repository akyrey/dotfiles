set path+=**

" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu

" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

" Automatic install of vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Place plugins required in the following block
call plug#begin()
" Install Material color theme
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
" Statusline configuration
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" Provides common configuration for various lsp servers
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'lspcontainers/lspcontainers.nvim'
Plug 'glepnir/lspsaga.nvim'
" Tree like structure to display symbols in file based on lsp
Plug 'simrat39/symbols-outline.nvim'
" Parser generator and parsing library
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'romgrk/nvim-treesitter-context'
" Comment multiple lines
Plug 'tpope/vim-commentary'
" Highlight todos
Plug 'folke/todo-comments.nvim'
" Auto completion and snippets
Plug 'hrsh7th/nvim-compe'
Plug 'akyrey/compe-tabnine', { 'do': './install.sh' }
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
" Fuzzy finder over list
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" Mark and easily navigate through files
Plug 'ThePrimeagen/harpoon'
" Formatter
Plug 'sbdchd/neoformat'
" Git management
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'ThePrimeagen/git-worktree.nvim'
" Man page inside vim
Plug 'vim-utils/vim-man'
" Visualize undo history
Plug 'mbbill/undotree'
" Metrics, insights and time tracking
Plug 'wakatime/vim-wakatime'
call plug#end()

" Colorscheme
if (has('termguicolors'))
  set termguicolors
endif

let g:material_theme_style = 'darker'
colorscheme material

" Color line numbers
hi LineNr ctermfg=0 guifg=#2196f3
hi CursorLineNr ctermfg=0 guifg=#FBC02D

lua init = require('init')
