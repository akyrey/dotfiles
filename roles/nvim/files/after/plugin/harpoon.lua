local m_ok, mark = pcall(require, "harpoon.mark")
local u_ok, ui = pcall(require, "harpoon.ui")

if not m_ok or not u_ok then
    return
end

vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [A]dd File" })
vim.keymap.set("n", "<leader>ht", ui.toggle_quick_menu, { desc = "[H]arpoon [T]oggle Quick Menu" })
vim.keymap.set("n", "<leader>hh", function() ui.nav_file(1) end, {})
vim.keymap.set("n", "<leader>hj", function() ui.nav_file(2) end, {})
vim.keymap.set("n", "<leader>hk", function() ui.nav_file(3) end, {})
vim.keymap.set("n", "<leader>hl", function() ui.nav_file(4) end, {})
