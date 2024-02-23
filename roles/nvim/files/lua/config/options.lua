-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable global autoformat
vim.g.autoformat = false

-- Avoid using system clipboard
vim.opt.clipboard = { "unnamed" }
-- Columns to highlight
vim.opt.colorcolumn = "120"
-- Where to store undo files
vim.opt.undodir = vim.fn.stdpath("data").."/undodir"
-- Save undo information in a file
vim.opt.undofile = true

-- Undercurl TODO: find how to enable this
-- vim.cmd([[let &t_Cs = " \e[4:3m]"]])
-- vim.cmd([[let &t_Ce = " \e[4:3m]"]])

-- Toggle quickfix listb
vim.cmd([[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]])
