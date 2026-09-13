-- Global keymaps.
--
-- Plugin-specific keymaps live in that plugin's spec under lua/plugins/, so
-- they load with the plugin. This file only holds bindings that work with no
-- plugins installed.

local map = vim.keymap.set

-- ---------------------------------------------------------------------------
-- Movement
-- ---------------------------------------------------------------------------

-- Move by display line when wrapping, unless a count was given.
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Keep the cursor centred while searching and scrolling.
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Prev search result" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- Join lines without moving the cursor to the join point.
map("n", "J", "mzJ`z", { desc = "Join line below" })

-- Y yanks to end of line, matching D and C.
map("n", "Y", "y$", { desc = "Yank to end of line" })

-- ---------------------------------------------------------------------------
-- Registers and clipboard
-- ---------------------------------------------------------------------------

-- The unnamed register is the default (see core/options.lua), so reaching the
-- system clipboard is explicit.
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })

-- Delete without clobbering the yank register.
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void register" })

-- ---------------------------------------------------------------------------
-- Insert mode
-- ---------------------------------------------------------------------------

map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "kj", "<ESC>", { desc = "Exit insert mode" })
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })

-- Undo break points, so a long insert can be undone in pieces.
for _, char in ipairs({ ",", ".", ";", "!", "?" }) do
  map("i", char, char .. "<c-g>u")
end

-- ---------------------------------------------------------------------------
-- Windows, splits and tabs
-- ---------------------------------------------------------------------------

-- <C-hjkl> is taken by harpoon, so resize with the arrow keys only.
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })

-- bufferline runs in tab mode, so these are the primary navigation.
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other tabs" })

-- ---------------------------------------------------------------------------
-- Buffers
-- ---------------------------------------------------------------------------

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>bD", "<cmd>bd<cr>", { desc = "Delete buffer and window" })

-- ---------------------------------------------------------------------------
-- Editing
-- ---------------------------------------------------------------------------

-- Move the current line or selection up and down.
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move up" })

-- Keep the selection after indenting.
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })

-- Comment on a new line above/below (gcc and gc are built in).
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- ---------------------------------------------------------------------------
-- Search highlighting
-- ---------------------------------------------------------------------------

map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    blink.hide()
  end
  return "<esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })

map(
  "n",
  "<leader>ur",
  "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- ---------------------------------------------------------------------------
-- Diagnostics
-- ---------------------------------------------------------------------------

map("n", "<leader>f", vim.diagnostic.open_float, { desc = "Open diagnostic float window" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Move diagnostics to location list" })

---@param severity vim.diagnostic.Severity?
local function diagnostic_goto(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, severity = severity and vim.diagnostic.severity[severity] or nil })
  end
end

map("n", "]d", diagnostic_goto(1), { desc = "Next diagnostic" })
map("n", "[d", diagnostic_goto(-1), { desc = "Prev diagnostic" })
map("n", "]e", diagnostic_goto(1, "ERROR"), { desc = "Next error" })
map("n", "[e", diagnostic_goto(-1, "ERROR"), { desc = "Prev error" })
map("n", "]w", diagnostic_goto(1, "WARN"), { desc = "Next warning" })
map("n", "[w", diagnostic_goto(-1, "WARN"), { desc = "Prev warning" })

-- ---------------------------------------------------------------------------
-- Quickfix and location list
-- ---------------------------------------------------------------------------

map("n", "<C-q>", function()
  local is_open = #vim.tbl_filter(function(win)
    return win.quickfix == 1
  end, vim.fn.getwininfo()) > 0
  vim.cmd(is_open and "cclose" or "copen")
end, { desc = "Toggle quickfix list" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- ---------------------------------------------------------------------------
-- Git conflict resolution (plain vim, no plugin needed)
-- ---------------------------------------------------------------------------

map("n", "<leader>vb", "<cmd>diffget //2<cr>", { desc = "Accept left conflict" })
map("n", "<leader>vn", "<cmd>diffget //3<cr>", { desc = "Accept right conflict" })

-- ---------------------------------------------------------------------------
-- Misc
-- ---------------------------------------------------------------------------

-- Open a tmux session picker without leaving nvim.
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "tmux sessionizer" })

map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect position" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect treesitter tree" })
