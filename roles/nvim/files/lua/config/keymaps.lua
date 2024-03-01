-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Reset mappings
vim.keymap.del("n", "<leader>xl")
vim.keymap.del("n", "<leader>xq")
vim.keymap.del({ "n", "t" }, "<C-h>")
vim.keymap.del({ "n", "t" }, "<C-j>")
vim.keymap.del({ "n", "t" }, "<C-k>")
vim.keymap.del({ "n", "t" }, "<C-l>")

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open netrw" })

-- Git related
vim.keymap.set("n", "<leader>vG", vim.cmd.G, { desc = "Fugitive" })
vim.keymap.set("n", "<leader>vh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })
vim.keymap.set("n", "<leader>vb", "<cmd>diffget //2<cr>", { desc = "Accept left conflict" })
vim.keymap.set("n", "<leader>vn", "<cmd>diffget //3<cr>", { desc = "Accept right conflict" })

-- Use tmux-sessionizer script inside nvim
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, { desc = "Open diagnostic float window" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Move diagnostics to local quickfix" })

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Copy until end of line to system clipboard" })

-- Delete to void register
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = "Delete to void registry" })

-- Quickfix navigation
vim.keymap.set("n", "<C-q>", ":call QuickFixToggle()<CR>", { desc = "Toggle quickfix list" })

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
-- vim.keymap.set("n", "k", "(v:count > 5 ? 'm`' . v:count : '') . 'k'", { noremap = true, expr = true, silent = true })
-- vim.keymap.set("n", "j", "(v:count > 5 ? 'm`' . v:count : '') . 'j'", { noremap = true, expr = true, silent = true })

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

-- Harpoon
vim.keymap.set("n", "<leader>ha", function()
  require("harpoon"):list():append()
end, { desc = "[H]arpoon [A]dd File" })
vim.keymap.set("n", "<leader>ht", function()
  require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "[H]arpoon [T]oggle Quick Menu" })
vim.keymap.set("n", "<C-h>", function()
  require("harpoon"):list():select(1)
end, { desc = "Harpoon file #1" })
vim.keymap.set("n", "<C-j>", function()
  require("harpoon"):list():select(2)
end, { desc = "Harpoon file #2" })
vim.keymap.set("n", "<C-k>", function()
  require("harpoon"):list():select(3)
end, { desc = "Harpoon file #3" })
vim.keymap.set("n", "<C-l>", function()
  require("harpoon"):list():select(4)
end, { desc = "Harpoon file #4" })

