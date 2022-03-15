local M = {}
local Log = require "akyrey.core.log"

M.config = function()
  akyrey.builtin.gitsigns = {
    active = true,
    on_config_done = nil,
    setup = {
      signs = {
        add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      },
      numhl = true,
      linehl = false,
      watch_gitdir = { interval = 1000 },
      current_line_blame = true,
      sign_priority = 6,
      update_debounce = 200,
      status_formatter = nil, -- Use default
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", "&diff ? ']c' : '<cmd>GitSigns next_hunk<CR>'", { expr = true })
      map("n", "[c", "&diff ? '[c' : '<cmd>GitSigns prev_hunk<CR>'", { expr = true })

      -- Actions
      map({ "n", "v" }, "<leader>vs", "<cmd>GitSigns stage_hunk<CR>")
      map({ "n", "v" }, "<leader>vr", "<cmd>GitSigns reset_hunk<CR>")
      map("n", "<leader>vu", "<cmd>GitSigns undo_stage_hunk<CR>")
      map("n", "<leader>vR", "<cmd>GitSigns reset_buffer<CR>")
      map("n", "<leader>vp", "<cmd>GitSigns preview_hunk<CR>")
      map("n", "<leader>vb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')

      -- Text objects
      map({ "o", "x" }, "ih", ":<C-U>GitSigns select_hunk()<CR>")
    end
  }
end

M.setup = function()
  local status_ok, gitsigns = pcall(require, "gitsigns")
  if not status_ok then
    Log:error "Failed to load gitsigns"
    return
  end
  gitsigns.setup(akyrey.builtin.gitsigns.setup)
  if akyrey.builtin.gitsigns.on_config_done then
    akyrey.builtin.gitsigns.on_config_done(gitsigns)
  end
end

return M
