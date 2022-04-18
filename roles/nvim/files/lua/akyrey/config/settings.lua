local M = {}

M.unload_default_plugins = function()
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

M.load_options = function()
  local opt = vim.opt

  local settings = {
    -- Don't keep backup file after overwriting a file
    backup = false,
    -- Number of lines to use for the command-line
    cmdheight = 2,
    -- Columns to highlight
    colorcolumn = "120",
    -- Options for Insert mode completion
    -- Required by auto completion plugin hrsh7th/nvim-compe
    completeopt = { "menuone", "noselect" },
    -- so that `` is visible in markdown files
    conceallevel = 0,
    -- Encoding used internally
    encoding = "UTF-8",
    -- Avoid making sounds on error
    errorbells = false,
    -- Use spaces when <Tab> is inserted
    expandtab = true,
    -- the encoding written to a file
    fileencoding = "utf-8",
    -- Don't unload buffer when it is abandoned
    hidden = true,
    -- Don't highlight matches with last search pattern
    hlsearch = false,
    -- ignore case in search patterns
    ignorecase = true,
    -- Highlight match while typing search pattern
    incsearch = true,
    -- Print the line number in front of each line
    nu = true,
    -- pop up menu height
    pumheight = 10,
    -- Show relative line number in front of each line
    relativenumber = true,
    -- Minimum nr. of lines above and below cursor
    scrolloff = 8,
    -- Number of spaces to use for (auto)indent step
    shiftwidth = 4,
    -- always show tabs
    showtabline = 4,
    -- Message on status line to show current mode
    showmode = false,
    -- When and how to display the sign column
    signcolumn = "yes",
    -- smart case
    smartcase = true,
    -- Put cursor at the right indentation after creating a new line
    smartindent = true,
    -- Number of spaces that <Tab> uses while editing
    softtabstop = 4,
    -- Setting spell (and spelllang) is mandatory to use spellsuggest
    spell = true,
    spelllang = { "en_us",  "it" },
    -- force all horizontal splits to go below current window
    splitbelow = true,
    -- force all vertical splits to go to the right of current window
    splitright = true,
    -- Don't use a swapfile for a buffer
    swapfile = false,
    -- Number of spaces that <Tab> in file uses
    tabstop = 4,
    -- set term gui colors (most terminals support this)
    termguicolors = true,
    -- time to wait for a mapped sequence to complete (in milliseconds)
    timeoutlen = 500,
    -- set the title of window to the value of the titlestring
    title = true,
    -- Where to store undo files
    undodir = vim.fn.stdpath('data').."/undodir",
    -- Save undo information in a file
    undofile = true,
    -- After this many milliseconds flush swap file
    updatetime = 300,
    -- Avoid wrapping long lines
    wrap = false,
    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    writebackup = false,
  }

  for k, v in pairs(settings) do
    vim.opt[k] = v
  end

  -- List of flags, reduce length of messages
  -- Don't pass messages to |ins-completion-menu|.
  opt.shortmess:append "c"

  -- Nice menu when typings `:find *.py`
  vim.cmd('set wildmode=longest,list,full')
  vim.cmd('set wildmenu')
  vim.cmd('set path+=**')
end

M.load_commands = function()
  local cmd = vim.cmd
  if akyrey.line_wrap_cursor_movement then
    cmd "set whichwrap+=<,>,[,],h,l"
  end

  if akyrey.transparent_window then
    cmd "au ColorScheme * hi Normal ctermbg=none guibg=none"
    cmd "au ColorScheme * hi SignColumn ctermbg=none guibg=none"
    cmd "au ColorScheme * hi NormalNC ctermbg=none guibg=none"
    cmd "au ColorScheme * hi MsgArea ctermbg=none guibg=none"
    cmd "au ColorScheme * hi TelescopeBorder ctermbg=none guibg=none"
    cmd "au ColorScheme * hi EndOfBuffer ctermbg=none guibg=none"
    cmd "let &fcs='eob: '"
  end
end

return M
