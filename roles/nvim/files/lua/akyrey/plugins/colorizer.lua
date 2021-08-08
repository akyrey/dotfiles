local function init()
  local present, colorizer = pcall(require, 'colorizer')
    if present then
      colorizer.setup()
      vim.cmd('ColorizerReloadAllBuffers')
  end
end

return {
  init = init,
}
