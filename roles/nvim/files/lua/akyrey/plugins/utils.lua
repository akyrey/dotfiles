local use_global_quick_list = true
local open_QF = false

local function toggle_global_or_local_QF()
  if use_global_quick_list then
    use_global_quick_list = false
    print('Using local quickfix list')
  else
    use_global_quick_list = true
    print('Using global quickfix list')
  end
end

local function toggle_QF()
  if use_global_quick_list then
    if open_QF then
      vim.cmd([[cclose]])
      open_QF = false
    else
      vim.cmd([[copen]])
      open_QF = true
    end
  else
    if open_QF then
      vim.cmd([[lclose]])
      open_QF = false
    else
      vim.cmd([[lopen]])
      open_QF = true
    end
  end
end

local function navigate_QF(next)
  if use_global_quick_list then
    if next then
      vim.cmd([[cnext]])
    else
      vim.cmd([[cprev]])
    end
  else
    if next then
      vim.cmd([[lnext]])
    else
      vim.cmd([[lprev]])
    end
  end
end

return {
  toggle_global_or_local_QF = toggle_global_or_local_QF,
  toggle_QF = toggle_QF,
  navigate_QF = navigate_QF,
}
