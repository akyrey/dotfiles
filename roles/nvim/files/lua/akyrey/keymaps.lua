-- This is where most of my basic keymapping goes.
--
--   Plugin keymaps will all be found in `./after/plugin/*`
--   Also check which-key.lua file

-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Toggle NvimTree", silent = true, noremap = true })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>vG", vim.cmd.G, { desc = "Fugitive" })
vim.keymap.set("n", "<leader>vg", require("akyrey.config.toggleterm").lazygit_toggle, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>vh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })
vim.keymap.set("n", "<leader>vb", "<cmd>diffget //2<cr>", { desc = "Accept left conflict" })
vim.keymap.set("n", "<leader>vn", "<cmd>diffget //3<cr>", { desc = "Accept right conflict" })

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
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "Copy to system clipboard" })
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

-- Telescope
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sD", ":Telescope diagnostics bufnr=0 theme=get_ivy<cr>",
{ desc = "[S]earch Buffer [D]iagnostics" })
vim.keymap.set("n", "<leader>sc", function() require("akyrey.config.telescope").find_config_files() end,
{ desc = "[S]earch [C]onfig" })
vim.keymap.set("n", "<leader>sC", function() require("akyrey.config.telescope").grep_config_files() end,
{ desc = "Grep [C]onfig" })

vim.keymap.set("n", "<leader>sW", function() require("telescope").extensions.git_worktree.git_worktrees() end,
{ desc = "[S]earch [W]orktrees" })
vim.keymap.set("n", "<leader>wc", function() require("telescope").extensions.git_worktree.create_git_worktree() end,
{ desc = "[W]orktree [C]reate" })
vim.keymap.set({ "n", "v" }, "<leader>rr", function() require("telescope").extensions.refactoring.refactors() end,
{ desc = "Open [R]efacto[r]ing Menu" })

vim.keymap.set("n", "<leader>ss", ":Telescope git_status<cr>", { desc = "[S]earch Git [S]tatus" })
vim.keymap.set("n", "<leader>sb", ":Telescope git_branches<cr>", { desc = "[S]earch [B]ranch" })
vim.keymap.set("n", "<leader>sv", ":Telescope git_commits<cr>", { desc = "[S]earch Commits" })
vim.keymap.set("n", "<leader>sV", ":Telescope git_bcommits<cr>", { desc = "[S]earch Commits for current file" })
vim.keymap.set("n", "<leader>sH", ":Telescope highlights<cr>", { desc = "[S]earch [H]ighlight gruops" })
vim.keymap.set("n", "<leader>sM", ":Telescope man_pages<cr>", { desc = "[S]earch [M]an Pages" })
vim.keymap.set("n", "<leader>sR", ":Telescope registers<cr>", { desc = "[S]earch [R]egisters" })
vim.keymap.set("n", "<leader>sk", ":Telescope keymaps<cr>", { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sC", ":Telescope commands<cr>", { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>sq", ":Telescope quickfix<cr>", { desc = "[S]earch [Q]uickfix list" })
vim.keymap.set("n", "<leader>st", ":TodoTelescope<cr>", { desc = "[S]earch [T]odo" })

-- Harpoon
vim.keymap.set("n", "<leader>ha", require("harpoon.mark").add_file, { desc = "[H]arpoon [A]dd File" })
vim.keymap.set("n", "<leader>ht", require("harpoon.ui").toggle_quick_menu, { desc = "[H]arpoon [T]oggle Quick Menu" })
vim.keymap.set("n", "<C-h>", function() require("harpoon.ui").nav_file(1) end, { desc = "Harpoon file #1" })
vim.keymap.set("n", "<C-j>", function() require("harpoon.ui").nav_file(2) end, { desc = "Harpoon file #2" })
vim.keymap.set("n", "<C-k>", function() require("harpoon.ui").nav_file(3) end, { desc = "Harpoon file #3" })
vim.keymap.set("n", "<C-l>", function() require("harpoon.ui").nav_file(4) end, { desc = "Harpoon file #4" })

-- Debugger
vim.keymap.set("n", "<leader>dt", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>db", function() require("dap").step_back() end, { desc = "Step Back" })
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
vim.keymap.set("n", "<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run To Cursor" })
vim.keymap.set("n", "<leader>dd", function() require("dap").disconnect() end, { desc = "Disconnect" })
vim.keymap.set("n", "<leader>dg", function() require("dap").session() end, { desc = "Get Session" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>du", function() require("dap").step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dp", function() require("dap").pause.toggle() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle Repl" })
vim.keymap.set("n", "<leader>ds", function() require("dap").continue() end, { desc = "Start" })
vim.keymap.set("n", "<leader>dq", function() require("dap").close() end, { desc = "Quit" })
vim.keymap.set("n", "<leader>dU", function() require("dapui").toggle({ reset = true }) end, { desc = "Toggle UI" })

-- Package-info
vim.keymap.set("n", "<leader>is", function() require('package-info').show() end, { desc = "Show package versions" })
vim.keymap.set("n", "<leader>ic", function() require('package-info').hide() end, { desc = "Hide package versions" })
vim.keymap.set("n", "<leader>iu", function() require('package-info').update() end, { desc = "Update package on line" })
vim.keymap.set("n", "<leader>id", function() require('package-info').delete() end, { desc = "Delete package on line" })
vim.keymap.set("n", "<leader>ii", function() require('package-info').install() end, { desc = "Install a new package" })
vim.keymap.set("n", "<leader>ir", function() require('package-info').reinstall() end, { desc = "Reinstall dependencies" })
vim.keymap.set("n", "<leader>ip", function() require('package-info').change_version() end,
{ desc = "Install a different package version" })
