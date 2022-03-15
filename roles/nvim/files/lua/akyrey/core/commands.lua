local M = {}

M.defaults = {
  [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
  ]],
  -- :AkyreyInfo
  [[command! AkyreyInfo lua require('akyrey.core.info').toggle_popup(vim.bo.filetype)]],
  [[ command! AkyreyCacheReset lua require('akyrey.utils.hooks').reset_cache() ]],
}

M.load = function(commands)
  for _, command in ipairs(commands) do
    vim.cmd(command)
  end
end

return M

