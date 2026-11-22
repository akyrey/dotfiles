-- Helpers around nvim-treesitter's `main` branch, which no longer has a
-- `configs.setup()` that turns features on globally. Instead each buffer opts
-- in, and these helpers answer "is there a parser/query for this?".
local M = {}

M._installed = nil ---@type table<string, boolean>?
M._queries = {} ---@type table<string, boolean>

--- Set of installed parser names, refreshed when `update` is true.
---@param update boolean?
function M.get_installed(update)
  if update or M._installed == nil then
    M._installed, M._queries = {}, {}
    local ok, ts = pcall(require, "nvim-treesitter")
    if ok and ts.get_installed then
      for _, lang in ipairs(ts.get_installed("parsers")) do
        M._installed[lang] = true
      end
    end
  end
  return M._installed or {}
end

---@param lang string
---@param query string
function M.have_query(lang, query)
  local key = lang .. ":" .. query
  if M._queries[key] == nil then
    M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return M._queries[key]
end

--- True when a parser exists for `what` (a filetype, buffer number, or nil for
--- the current buffer) and, if given, a query of that kind is available.
---@param what string|number|nil
---@param query string?
---@return boolean
function M.have(what, query)
  what = what or vim.api.nvim_get_current_buf()
  what = type(what) == "number" and vim.bo[what].filetype or what --[[@as string]]
  local lang = vim.treesitter.language.get_lang(what)
  if lang == nil or M.get_installed()[lang] == nil then
    return false
  end
  if query and not M.have_query(lang, query) then
    return false
  end
  return true
end

--- 'foldexpr' that falls back to no folding when treesitter can't help.
function M.foldexpr()
  return M.have(nil, "folds") and vim.treesitter.foldexpr() or "0"
end

--- 'indentexpr' that falls back to Neovim's built-in indenting.
function M.indentexpr()
  if not M.have(nil, "indents") then
    return -1
  end
  return require("nvim-treesitter").indentexpr()
end

return M
