local M = {}
-- Leader key -> " "
--
-- In general, it's a good idea to set this early in your config, because otherwise
-- if you have any mappings you set BEFORE doing this, they will be set to the OLD
-- leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local generic_opts_any = { noremap = true, silent = true }
M.generic_opts_any = generic_opts_any

-- This is where most of my basic keymapping goes.
--
--   Plugin keymaps will all be found in `./after/plugin/*`

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, generic_opts_any)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, generic_opts_any)

-- Use tmux-sessionizer script inside nvim
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Better window movement
vim.keymap.set("n", "<C-h>", "<C-w>h", generic_opts_any)
vim.keymap.set("n", "<C-j>", "<C-w>j", generic_opts_any)
vim.keymap.set("n", "<C-k>", "<C-w>k", generic_opts_any)
vim.keymap.set("n", "<C-l>", "<C-w>l", generic_opts_any)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, generic_opts_any)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, generic_opts_any)
vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, generic_opts_any)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, generic_opts_any)

-- Quickfix navigation
vim.keymap.set("n", "<C-q>", ":call QuickFixToggle()<CR>", generic_opts_any)
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", generic_opts_any)
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", generic_opts_any)
-- vim.keymap.set("n", "<A-j>", "<cmd>lprev<CR>zz", generic_opts_any)
-- vim.keymap.set("n", "<A-k>", "<cmd>lnext<CR>zz", generic_opts_any)

-- Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "Q", "<Nop>", { silent = true })

-- Copy to system clipboard
vim.keymap.set({ "n" , "v" }, "<leader>y", "\"+y", generic_opts_any)
vim.keymap.set("n", "<leader>Y", "\"+Y", generic_opts_any)

-- Delete to void register
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", generic_opts_any)

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? \"gk\" : \"k\"", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? \"gj\" : \"j\"", { expr = true, silent = true })

-- Y will yank from cursor until the end of the line instead of entire line
vim.keymap.set("n", "Y", "yg$", generic_opts_any)
-- Keeping cursor centered on search operations
vim.keymap.set("n", "n", "nzzzv", generic_opts_any)
vim.keymap.set("n", "N", "Nzzzv", generic_opts_any)
-- Keeping cursor centered on page scroll operations
vim.keymap.set("n", "<C-d>", "<C-d>zz", generic_opts_any)
vim.keymap.set("n", "<C-u>", "<C-u>zz", generic_opts_any)
-- Append next line to current keeping cursor position
vim.keymap.set("n", "J", "mzJ`z", generic_opts_any)
-- Jumplist update on relative motions
vim.keymap.set("n", "k", "(v:count > 5 ? 'm`' . v:count : '') . 'k'", { noremap = true, expr = true, silent = true })
vim.keymap.set("n", "j", "(v:count > 5 ? 'm`' . v:count : '') . 'j'", { noremap = true, expr = true, silent = true })
-- Move current line / block
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", generic_opts_any)
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", generic_opts_any)

-- 'jk' for quitting insert mode
vim.keymap.set("i", "jk", "<ESC>", generic_opts_any)
-- 'kj' for quitting insert mode
vim.keymap.set("i", "kj", "<ESC>", generic_opts_any)
-- 'jj' for quitting insert mode
vim.keymap.set("i", "jj", "<ESC>", generic_opts_any)
-- Undo break points
vim.keymap.set("i", ",", ",<c-g>u", generic_opts_any)
vim.keymap.set("i", ".", ".<c-g>u", generic_opts_any)
vim.keymap.set("i", "!", "!<c-g>u", generic_opts_any)
vim.keymap.set("i", "?", "?<c-g>u", generic_opts_any)
-- Move current line / block
vim.keymap.set("i", "<A-j>", "<esc>:m .+1<CR>==gi", generic_opts_any)
vim.keymap.set("i", "<A-k>", "<esc>:m .-2<CR>==gi", generic_opts_any)

-- Moving highlighted text
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", generic_opts_any)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", generic_opts_any)

-- Better indenting
vim.keymap.set("v", "<", "<gv", generic_opts_any)
vim.keymap.set("v", ">", ">gv", generic_opts_any)

-- Move selected line / block of text in visual mode
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", generic_opts_any)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", generic_opts_any)

-- Paste on highlighted text without overwriting copied value
vim.keymap.set("x", "<leader>p", "\"_dP", generic_opts_any)

vim.keymap.set("c", "%%", "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { noremap = true, expr = true })

return M
