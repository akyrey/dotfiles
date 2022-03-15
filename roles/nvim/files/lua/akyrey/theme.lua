local M = {}

M.setup = function()
  local cmd = vim.cmd
  vim.g.colors_name = akyrey.colorscheme -- Colorscheme must get called after plugins are loaded or it will break new installs.
  cmd("colorscheme " .. akyrey.colorscheme)
  cmd("highlight NonText guifg='#2196f3'")

  -- Color line numbers
  cmd("hi LineNr ctermfg=0 guifg='#2196f3'")
  cmd("hi CursorLineNr ctermfg=0 guifg='#FBC02D'")

  cmd('set termguicolors')
  -- Change cursor shape for all modes
  cmd('set guicursor=n-v-c:block-Cursor-blinkon0')
  cmd('set guicursor+=ve:ver35-Cursor')
  cmd('set guicursor+=o:hor50-Cursor-blinkwait175-blinkoff150-blinkon175')
  cmd('set guicursor+=i-ci:ver20-Cursor')
  cmd('set guicursor+=r-cr:hor20-Cursor')
  cmd('set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175')
end

return M
