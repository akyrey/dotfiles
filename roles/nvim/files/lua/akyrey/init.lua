local function init()
  require'akyrey.vim'.init()
  require'akyrey.packer'.init()
end

return {
  init = init,
}
