-- Expand `-` to `->` when typed right after an identifier, `)` or `]`
-- ($this-, ->getFoo()-, $arr['key']-), so a property/method chain needs only
-- `-`. Skips string and line-comment contexts via a plain scan of the text
-- before the cursor: treesitter's parse tree lags behind the character
-- that's currently being typed (most visibly inside a fresh `//` comment),
-- so it isn't reliable for this same-keystroke check.
local function in_string_or_comment(before_cursor)
  local hash = before_cursor:find("#")
  if before_cursor:find("//", 1, true) or (hash and before_cursor:sub(hash, hash + 1) ~= "#[") then
    return true
  end

  local in_single, in_double = false, false
  local i = 1
  while i <= #before_cursor do
    local char = before_cursor:sub(i, i)
    if char == "\\" then
      i = i + 1
    elseif char == "'" and not in_double then
      in_single = not in_single
    elseif char == '"' and not in_single then
      in_double = not in_double
    end
    i = i + 1
  end

  return in_single or in_double
end

vim.keymap.set("i", "-", function()
  local col = vim.fn.col(".") - 1
  local line = vim.fn.getline(".")
  local char_before = line:sub(col, col)

  if char_before:match("[%w_%$%)%]]") and not in_string_or_comment(line:sub(1, col)) then
    return "->"
  end

  return "-"
end, { buffer = true, expr = true, desc = "Expand -> after an identifier" })
