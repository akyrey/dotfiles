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
    signcolumn = yes,
    -- Put cursor at the right indentation after creating a new line
    smartindent = true,
    -- Number of spaces that <Tab> uses while editing
    softtabstop = 2,
    -- Don't use a swapfile for a buffer
    swapfile = false,
    -- Number of spaces that <Tab> in file uses
    tabstop = 2,
    -- Where to store undo files
    undodir = "$HOME/.vim/undodir",
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
end

local function set_keymaps()
  local map = vim.api.nvim_set_keymap
  local options = { noremap = false }

  -- ------------------- --
  --      Navigation     --
  -- ------------------- --
  -- Go to next occurence in global quickfix list
  map('n', '<leader><C-k>', '<CMD>cnext<CR>zz', options)
  -- Go to previous occurence in global quickfix list
  map('n', '<leader><C-j>', '<CMD>cprev<CR>zz', options)
  -- Go to next occurence in local quickfix list
  map('n', '<leader>k', '<CMD>lnext<CR>zz', options)
  -- Go to previous occurence in local quickfix list
  map('n', '<leader>j', '<CMD>lprev<CR>zz', options)
  -- Open global quickfix list
  map('n', '<C-q>', '<CMD>call ToggleQFList(1)<CR>', options)
  -- Open local quickfix list
  map('n', '<leader>q', '<CMD>call ToggleQFList(0)<CR>', options)
  -- ------------------- --
  --          LSP        --
  -- ------------------- --
  map('n', '<leader>vd', "<CMD>lua vim.lsp.buf.definition()<CR>", options)
  map('n', '<leader>vi', "<CMD>lua vim.lsp.buf.implementation()<CR>", options)
  map('n', '<leader>vsh', "<CMD>lua vim.lsp.buf.signature_help()<CR>", options)
  map('n', '<leader>vrr', "<CMD>lua vim.lsp.buf.references()<CR>", options)
  map('n', '<leader>vrn', "<CMD>lua vim.lsp.buf.rename()<CR>", options)
  map('n', '<leader>vh', "<CMD>lua vim.lsp.buf.hover()<CR>", options)
  map('n', '<leader>vca', "<CMD>lua vim.lsp.buf.code_action()<CR>", options)
  map('n', '<leader>vsd', "<CMD>lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>", options)
  map('n', '<leader>vn', "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>", options)
  map('n', '<leader>vll', "<CMD>call LspLocationList()<CR>", options)
  -- ------------------- --
  --        Harpoon      --
  -- ------------------- --
  map('n', '<leader>ha', "<CMD>lua require('harpoon.mark').add_file()<CR>", options)
  map('n', '<C-e>', "<CMD>lua require('harpoon.ui').toggle_quick_menu()<CR>", options)
  map('n', '<C-h>', "<CMD>lua require('harpoon.ui').nav_file(1)<CR>", options)
  map('n', '<C-j>', "<CMD>lua require('harpoon.ui').nav_file(2)<CR>", options)
  map('n', '<C-k>', "<CMD>lua require('harpoon.ui').nav_file(3)<CR>", options)
  map('n', '<C-l>', "<CMD>lua require('harpoon.ui').nav_file(4)<CR>", options)
  map('n', '<leader>ts', "<CMD>lua require('harpoon.term').gotoTerminal(1)<CR>", options)
  map('n', '<leader>td', "<CMD>lua require('harpoon.term').gotoTerminal(2)<CR>", options)
  map('n', '<leader>cs', "<CMD>lua require('harpoon.term').sendCommand(1, 1)<CR>", options)
  map('n', '<leader>cd', "<CMD>lua require('harpoon.term').sendCommand(1, 2)<CR>", options)
  -- ------------------- --
  --       NERDTree      --
  -- ------------------- --
  map('n', '<Alt-1>', '<CMD>NERDTreeToggle<CR>', options)
  -- ------------------- --
  --      Telescope      --
  -- ------------------- --
  -- Searches for the string under your cursor in your current working directory
  map('n', '<leader>ps', "<CMD>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ')})<CR>", options)
  -- Fuzzy search through the output of git ls-files command, respects .gitignore, optionally ignores untracked files
  map('n', '<C-p>', "<CMD>lua require('telescope.builtin').git_files()<CR>", options)
  -- Lists files in your current working directory, respects .gitignore
  map('n', '<Leader>pf', "<CMD>lua require('telescope.builtin').find_files()<CR>", options)
  -- Searches for the string under your cursor in your current working directory
  map('n', '<leader>pw', "<CMD>lua require('telescope.builtin').grep_string { search = vim.fn.expand('<cword>') }<CR>", options)
  -- Lists open buffers in current neovim instance
  map('n', '<leader>pb', "<CMD>lua require('telescope.builtin').buffers()<CR>", options)
  -- Lists available help tags and opens a new window with the relevant help info on <cr>
  map('n', '<leader>vh', "<CMD>lua require('telescope.builtin').help_tags()<CR>", options)
  -- Search by tree-sitter symbols
  map('n', '<leader>pt', "<CMD>lua require('telescope.builtin').treesitter()<CR>", options)
end

local function init()
  set_augroup_to_wrap_markdown()
  set_yank_highlight()
  set_vim_g()
  set_vim_o()
  set_keymaps()
end

return {
  init = init
}
