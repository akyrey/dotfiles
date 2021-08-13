local function unload_plugins()
  local disabled_built_ins = {
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
  }

  for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

local function set_vim_g()
  vim.g.mapleader = " "
end

local function set_yank_highlight()
  vim.api.nvim_command("augroup HighlightYank")
  vim.api.nvim_command("autocmd!")
  vim.api.nvim_command("autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 60})")
  vim.api.nvim_command("augroup END")
end

local function set_augroup_to_wrap_markdown()
  vim.api.nvim_command("augroup WrapInMarkdown")
  vim.api.nvim_command("autocmd!")
  vim.api.nvim_command("autocmd FileType markdown setlocal wrap")
  vim.api.nvim_command("augroup END")
end

local function set_vim_o()
  local settings = {
    -- Don't keep backup file after overwriting a file
    backup = false,
    -- Number of lines to use for the command-line
    cmdheight = 1,
    -- Columns to highlight
    colorcolumn = "120",
    -- Encoding used internally
    encoding = "UTF-8",
    -- Avoid making sounds on error
    errorbells = false,
    -- Use spaces when <Tab> is inserted
    expandtab = true,
    -- Don't unload buffer when it is abandoned
    hidden = true,
    -- Don't highlight matches with last search pattern
    hlsearch = false,
    -- Highlight match while typing search pattern
    incsearch = true,
    -- Print the line number in front of each line
    nu = true,
    -- Show relative line number in front of each line
    relativenumber = true,
    -- Minimum nr. of lines above and below cursor
    scrolloff = 8,
    -- Number of spaces to use for (auto)indent step
    shiftwidth = 2,
    -- Message on status line to show current mode
    showmode = false,
    -- When and how to display the sign column
    signcolumn = "yes",
    -- Put cursor at the right indentation after creating a new line
    smartindent = true,
    -- Number of spaces that <Tab> uses while editing
    softtabstop = 2,
    -- Don't use a swapfile for a buffer
    swapfile = false,
    -- Number of spaces that <Tab> in file uses
    tabstop = 2,
    -- Where to store undo files
    undodir = vim.fn.stdpath('data').."/undodir",
    -- Save undo information in a file
    undofile = true,
    -- After this many milliseconds flush swap file
    updatetime = 300,
    -- Avoid wrapping long lines
    wrap = false,
  }

  for k, v in pairs(settings) do
    vim.o[k] = v
  end

  -- ------------------- --
  -- Not yet in vim.o
  -- ------------------- --
  -- List of flags, reduce length of messages
  -- Don't pass messages to |ins-completion-menu|.
  vim.cmd('set shortmess+=c')
  vim.cmd('set termguicolors')
  -- Options for Insert mode completion
  -- Required by auto completion plugin hrsh7th/nvim-compe
  vim.cmd('set completeopt=menuone,noselect')
  -- Change cursor shape for all modes
  vim.cmd('set guicursor=n-v-c:block-Cursor-blinkon0')
  vim.cmd('set guicursor+=ve:ver35-Cursor')
  vim.cmd('set guicursor+=o:hor50-Cursor-blinkwait175-blinkoff150-blinkon175')
  vim.cmd('set guicursor+=i-ci:ver20-Cursor')
  vim.cmd('set guicursor+=r-cr:hor20-Cursor')
  vim.cmd('set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175')

  -- Nice menu when typings `:find *.py`
  vim.cmd('set wildmode=longest,list,full')
  vim.cmd('set wildmenu')
  vim.cmd('set path+=**')
end

local function set_keymaps()
  local map = vim.api.nvim_set_keymap
  local options = { noremap = true }

  -- Y will yank from cursor until the end of the line instead of entire line
  map('n', 'Y', 'y$', options)
  -- Keeping cursor centered on search operations
  map('n', 'n', 'nzzzv', options)
  map('n', 'N', 'Nzzzv', options)
  map('n', 'J', 'mzJ`z', options)
  -- Undo break points
  map('i', ',', ',<c-g>u', options)
  map('i', '.', '.<c-g>u', options)
  map('i', '!', '!<c-g>u', options)
  map('i', '?', '?<c-g>u', options)
  -- Jumplist update on relative motions
  map('n', 'k', '(v:count > 5 ? "m`" . v:count : "") . "k"', { noremap = true, expr = true, silent = true })
  map('n', 'j', '(v:count > 5 ? "m`" . v:count : "") . "j"', { noremap = true, expr = true, silent = true })
  -- Moving text
  map('v', 'J', ':m \'>+1<CR>gv=gv', options)
  map('v', 'K', ':m \'<-2<CR>gv=gv', options)
  map('i', '<C-j>', '<esc>:m .+1<CR>V', options)
  map('i', '<C-k>', '<esc>:m .-2<CR>V', options)
  map('n', '<leader>j', ':m .+1<CR>==', options)
  map('n', '<leader>k', ':m .-2<CR>==', options)

  -- ------------------- --
  --      Navigation     --
  -- ------------------- --
  -- Go to next occurence in local quickfix list
  map('n', '<leader>nk', "<CMD>lua require('akyrey.plugins.utils').navigate_QF(true)<CR>zz", options)
  -- Go to previous occurence in local quickfix list
  map('n', '<leader>nj', "<CMD>lua require('akyrey.plugins.utils').navigate_QF(false)<CR>zz", options)
  -- Open global quickfix list
  map('n', '<leader>nq', "<CMD>lua require('akyrey.plugins.utils').toggle_global_or_local_QF()<CR>", options)
  -- Open local quickfix list
  map('n', '<leader>nt', "<CMD>lua require('akyrey.plugins.utils').toggle_QF()<CR>", options)
  -- ------------------- --
  --          LSP        --
  -- ------------------- --
  -- Moved to lspconfig.lua
  -- ------------------- --
  --        Harpoon      --
  -- ------------------- --
  map('n', '<leader>ha', "<CMD>lua require('harpoon.mark').add_file()<CR>", options)
  map('n', '<C-e>', "<CMD>lua require('harpoon.ui').toggle_quick_menu()<CR>", options)
  map('n', '<C-h>', "<CMD>lua require('harpoon.ui').nav_file(1)<CR>", options)
  map('n', '<C-j>', "<CMD>lua require('harpoon.ui').nav_file(2)<CR>", options)
  map('n', '<C-k>', "<CMD>lua require('harpoon.ui').nav_file(3)<CR>", options)
  map('n', '<C-l>', "<CMD>lua require('harpoon.ui').nav_file(4)<CR>", options)
  -- ------------------- --
  --    File explorer    --
  -- ------------------- --
  -- map('n', '¡', '<CMD>NERDTreeToggle<CR>', options)
  map('n', '<leader>dc', '<CMD>Ex<CR>', options)
  map('n', '<leader>dt', '<CMD>NvimTreeToggle<CR>', options)
  -- ------------------- --
  --      Telescope      --
  -- ------------------- --
  -- Searches all project by a string
  map('n', '<leader>fs', "<CMD>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ')})<CR>", options)
  -- Fuzzy search through the output of git ls-files command, respects .gitignore, optionally ignores untracked files
  map('n', '<C-f>', "<CMD>lua require('telescope.builtin').git_files()<CR>", options)
  -- Lists files in your current working directory, respects .gitignore
  map('n', '<Leader>ff', "<CMD>lua require('telescope.builtin').find_files()<CR>", options)
  -- Searches for the string under your cursor in your current working directory
  map('n', '<leader>fw', "<CMD>lua require('telescope.builtin').grep_string { search = vim.fn.expand('<cword>') }<CR>", options)
  -- Lists open buffers in current neovim instance
  map('n', '<leader>fb', "<CMD>lua require('telescope.builtin').buffers()<CR>", options)
  -- Lists available help tags and opens a new window with the relevant help info on <cr>
  map('n', '<leader>fh', "<CMD>lua require('telescope.builtin').help_tags()<CR>", options)
  -- Search by tree-sitter symbols
  map('n', '<leader>ft', "<CMD>lua require('telescope.builtin').treesitter()<CR>", options)
  -- List git branches
  map('n', '<leader>fg', '<CMD>lua require("telescope.builtin").git_branches()<CR>', options)
  -- List worktrees
  map('n', '<leader>fgw', '<CMD>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>', options)
  -- Search in vimrc configuration folder
  map('n', '<leader>frc', "<CMD>lua require('akyrey.plugins.telescope').search_dotfiles()<CR>", options)
  -- ------------------- --
  --    Git Worktree     --
  -- ------------------- --
  map('n', '<leader>wc', '<CMD>lua require("git-worktree").create_worktree(vim.fn.input("Worktree name > "), vim.fn.input("Worktree upstream > "))<CR>', options)
  map('n', '<leader>ws', '<CMD>lua require("git-worktree").switch_worktree(vim.fn.input("Worktree name > "))<CR>', options)
  map('n', '<leader>wd', '<CMD>lua require("git-worktree").delete_worktree(vim.fn.input("Worktree name > "))<CR>', options)
  -- ------------------- --
  --    Git Fugitive     --
  -- ------------------- --
  map('n', '<leader>vs', '<CMD>G<CR>', options)
  map('n', '<leader>vg', '<CMD>diffget //2<CR>', options)
  map('n', '<leader>vh', '<CMD>diffget //3<CR>', options)
end

local function set_ignored()
  vim.cmd('set wildignore+=*.pyc')
  vim.cmd('set wildignore+=*_build/*')
  vim.cmd('set wildignore+=**/coverage/*')
  vim.cmd('set wildignore+=**/node_modules/*')
  vim.cmd('set wildignore+=**/android/*')
  vim.cmd('set wildignore+=**/ios/*')
  vim.cmd('set wildignore+=**/.git/*')
end

local function init()
  unload_plugins()
  -- set_augroup_to_wrap_markdown()
  set_yank_highlight()
  set_vim_g()
  set_vim_o()
  set_keymaps()
  set_ignored()
end

return {
  init = init
}
