-- Global options. Ported explicitly from LazyVim's defaults so every line here
-- is one we chose to keep, followed by our own overrides.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Never format on save by default; `<leader>uf` toggles it per buffer/session.
vim.g.autoformat = false

-- Root detection spec, consumed by lua/core/root.lua.
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
vim.g.root_lsp_ignore = { "copilot", "null-ls" }

-- snacks.nvim animations
vim.g.snacks_animate = true

-- Use Neovim's own markdown indent rules rather than the bundled "recommended" ones.
vim.g.markdown_recommended_style = 0

local opt = vim.opt

-- Files and buffers
opt.autowrite = true -- write the buffer when leaving it
opt.confirm = true -- ask instead of failing when abandoning a modified buffer
opt.undofile = true
opt.undolevels = 10000
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.updatetime = 200 -- also drives CursorHold / gitsigns blame

-- Clipboard: stay on the unnamed register, copy to the system clipboard
-- explicitly with <leader>y. Avoids every delete clobbering the system clipboard.
opt.clipboard = { "unnamed" }

-- Indentation
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit" -- live preview for :s
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- UI
opt.colorcolumn = "120"
opt.conceallevel = 2
opt.cursorline = true
opt.laststatus = 3 -- one global statusline
opt.linebreak = true
opt.list = true
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.pumblend = 0
opt.pumheight = 10
opt.ruler = false
opt.scrolloff = 4
opt.showmode = false -- the statusline already shows it
opt.sidescrolloff = 8
opt.signcolumn = "yes" -- always reserve it so text doesn't shift
opt.smoothscroll = true
opt.termguicolors = true
opt.virtualedit = "block"
opt.winblend = 0
opt.winminwidth = 5
opt.wrap = false
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Windows and splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Command line and completion
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"
opt.timeoutlen = 300 -- how long which-key waits

-- Misc
opt.formatoptions = "jcroqlnt"
opt.jumpoptions = "view"
opt.spelllang = { "en" }
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Formatting via conform.nvim, so `gq` uses the configured formatter.
opt.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Folding: treesitter where a parser exists, indent everywhere else.
opt.foldlevel = 99
opt.foldtext = ""
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'util.treesitter'.foldexpr()"

-- Undercurl support in terminals that understand it.
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
