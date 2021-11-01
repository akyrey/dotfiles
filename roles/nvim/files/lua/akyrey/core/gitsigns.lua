local M = {}
local Log = require "akyrey.core.log"

M.config = function()
  akyrey.builtin.gitsigns = {
    active = true,
    on_config_done = nil,
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "▎",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = "▎",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = "契",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "契",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "▎",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
    },
    numhl = true,
    linehl = false,
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,

      ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
      ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

      ["n <leader>vs"] = "<cmd>lua require'gitsigns'.stage_hunk()<CR>",
      ["n <leader>vu"] = "<cmd>lua require'gitsigns'.undo_stage_hunk()<CR>",
      ["n <leader>vr"] = "<cmd>lua require'gitsigns'.reset_hunk()<CR>",
      ["n <leader>vR"] = "<cmd>lua require'gitsigns'.reset_buffer()<CR>",
      ["n <leader>vp"] = "<cmd>lua require'gitsigns'.preview_hunk()<CR>",
      ["n <leader>vb"] = "<cmd>lua require'gitsigns'.blame_line(true)<CR>",

      -- Text objects
      ["o ih"] = ":<C-U>lua require'gitsigns.actions'.select_hunk()<CR>",
      ["x ih"] = ":<C-U>lua require'gitsigns.actions'.select_hunk()<CR>",
    },
    watch_gitdir = { interval = 1000 },
    current_line_blame = true,
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil, -- Use default
  }
end

M.setup = function()
  local status_ok, gitsigns = pcall(require, "gitsigns")
  if not status_ok then
    Log:error "Failed to load gitsigns"
    return
  end
  gitsigns.setup(akyrey.builtin.gitsigns)
  if akyrey.builtin.gitsigns.on_config_done then
    akyrey.builtin.gitsigns.on_config_done(gitsigns)
  end
end

return M
