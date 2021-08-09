local function init()
  require('lualine').setup {
    options = {
      extensions = { 'fugitive', 'quickfix' },
      theme = 'material'
    }
  }
end

return {
  init = init
}
