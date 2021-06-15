local function init()
  require('lualine').setup {
    options = {
      extensions = { 'fzf', 'quickfix' },
      theme = 'material'
    }
  }
end

return {
  init = init
}
