local M = {}
-- Leader key -> " "
--
-- In general, it's a good idea to set this early in your config, because otherwise
-- if you have any mappings you set BEFORE doing this, they will be set to the OLD
-- leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- This is where most of my basic keymapping goes.
--
--   Plugin keymaps will all be found in `./after/plugin/*`
--   Also check which-key.lua file

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>vG", vim.cmd.G, { desc = "Fugitive" })
vim.keymap.set("n", "<leader>vh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })

vim.keymap.set("n", "<leader>b", "<cmd>b#<cr>", { desc = "Goto previous buffer" })

-- Use tmux-sessionizer script inside nvim
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Packer related
vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>", { desc = "[P]acker [C]ompile" })
vim.keymap.set("n", "<leader>pi", "<cmd>PackerInstall<cr>", { desc = "[P]acker [I]nstall" })
vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>", { desc = "[P]acker [S]ync" })
vim.keymap.set("n", "<leader>pS", "<cmd>PackerStatus<cr>", { desc = "[P]acker [S]tatus" })
vim.keymap.set("n", "<leader>pu", "<cmd>PackerUpdate<cr>", { desc = "[P]acker [U]pdate" })

-- Better window movement (<C-#> currently used by Harpoon)
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, { desc = "Open diagnostic float window" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Move diagnostics to local quickfix" })

-- Quickfix navigation
vim.keymap.set("n", "<C-q>", ":call QuickFixToggle()<CR>", { desc = "Toggle quickfix list" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix list item" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix list item" })
vim.keymap.set("n", "[Q", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })
vim.keymap.set("n", "]Q", "<cmd>lnext<CR>zz", { desc = "Next location list item" })

-- Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "Q", "<Nop>", { silent = true })

-- Copy to system clipboard
vim.keymap.set({ "n" , "v" }, "<leader>y", "\"+y", { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Copy until end of line to system clipboard" })

-- Delete to void register
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = "Delete to void registry" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? \"gk\" : \"k\"", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? \"gj\" : \"j\"", { expr = true, silent = true })

-- Y will yank from cursor until the end of the line instead of entire line
vim.keymap.set("n", "Y", "yg$")
-- Keeping cursor centered on search operations
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Keeping cursor centered on page scroll operations
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Append next line to current keeping cursor position
vim.keymap.set("n", "J", "mzJ`z")
-- Jumplist update on relative motions
vim.keymap.set("n", "k", "(v:count > 5 ? 'm`' . v:count : '') . 'k'", { noremap = true, expr = true, silent = true })
vim.keymap.set("n", "j", "(v:count > 5 ? 'm`' . v:count : '') . 'j'", { noremap = true, expr = true, silent = true })
-- Move current line / block
-- vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
-- vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")

-- 'jk' for quitting insert mode
vim.keymap.set("i", "jk", "<ESC>")
-- 'kj' for quitting insert mode
vim.keymap.set("i", "kj", "<ESC>")
-- 'jj' for quitting insert mode
vim.keymap.set("i", "jj", "<ESC>")
-- Undo break points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")
-- Move current line / block
-- vim.keymap.set("i", "<A-j>", "<esc>:m .+1<CR>==gi")
-- vim.keymap.set("i", "<A-k>", "<esc>:m .-2<CR>==gi")

-- Moving highlighted text
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move selected line / block of text in visual mode
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv")

vim.keymap.set("c", "%%", "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { noremap = true, expr = true })

return M
