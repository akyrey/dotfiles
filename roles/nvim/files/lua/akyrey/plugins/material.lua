local function init()
  -- Theme settings
  vim.g.material_theme_style = 'darker'

  -- Load colorscheme
  vim.cmd[[colorscheme material]]
  vim.cmd[[hi LineNr ctermfg=0 guifg='#2196f3']]
  vim.cmd[[hi CursorLineNr ctermfg=0 guifg='#FBC02D']]
end

return {
  init = init,
}
