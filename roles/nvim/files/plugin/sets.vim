" Change cursor shape for all modes
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=ve:ver35-Cursor
set guicursor+=o:hor50-Cursor-blinkwait175-blinkoff150-blinkon175
set guicursor+=i-ci:ver20-Cursor
set guicursor+=r-cr:hor20-Cursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
" Display current line number
set nu
" Line numbers relative to current one
set relativenumber
" Avoid leaving highlighted search text
set nohlsearch
set hidden
" Avoid making sounds on error
set noerrorbells
" Spaces for each tab
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
" Put cursor at the right indentation after creating a new line
set smartindent
" Avoid wrapping long lines
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
" set noshowmode
set signcolumn=yes
set isfname+=@-@
" set ls=0
" Give more space for displaying messages.
set cmdheight=1
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Red colored column marking max code width
set colorcolumn=120
" Required by auto completion plugin hrsh7th/nvim-compe
set completeopt=menuone,noselect
