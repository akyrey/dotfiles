-- The single definition of "project root" for this config.
--
-- Two questions share one set of markers:
--   * `M.project()` / `M.find()`: the directory that owns a file, found by
--     walking up to the nearest marker. Used by PHP tooling (formatters,
--     linters, tests), which must run where composer.json and vendor/ live.
--   * `M.get()`: the root pickers and the explorer open in. Prefers what an
--     attached language server reports, then falls back to `M.project()`.
local M = {}

--- Markers in priority order: composer.json is searched all the way up before
--- anything else, so a PHP project nested inside a larger git repository (or
--- next to a package.json) roots at itself.
M.MARKERS = { "composer.json", "go.mod", "package.json", ".git" }

--- LSP clients whose root is never a project root.
local LSP_IGNORE = { "copilot" }

--- Nearest directory holding one of `M.MARKERS`, or nil when there is none.
---@param source? integer|string buffer number or path, defaults to the current buffer
---@return string?
function M.find(source)
  return vim.fs.root(source or 0, M.MARKERS)
end

--- Like `M.find()`, falling back to the cwd.
---@param source? integer|string buffer number or path, defaults to the current buffer
---@return string
function M.project(source)
  return M.find(source) or vim.uv.cwd()
end

--- Normalised real path of a buffer's file, or nil for unnamed buffers.
---@param buf integer
---@return string?
local function bufpath(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return nil
  end
  return vim.fs.normalize(vim.uv.fs_realpath(name) or name)
end

--- Roots reported by LSP clients attached to the buffer that contain its file,
--- deepest first.
---@param buf integer
---@return string[]
local function lsp_roots(buf)
  local path = bufpath(buf)
  if not path then
    return {}
  end
  local roots = {} ---@type string[]
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if not vim.tbl_contains(LSP_IGNORE, client.name) then
      local candidates = vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, client.workspace_folders or {})
      table.insert(candidates, client.root_dir)
      for _, root in ipairs(candidates) do
        root = vim.fs.normalize(root)
        if vim.fs.relpath(root, path) and not vim.tbl_contains(roots, root) then
          table.insert(roots, root)
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  return roots
end

--- The root for pickers and the explorer: the deepest LSP root containing the
--- buffer's file, else `M.project()`.
---@param buf? integer defaults to the current buffer
---@return string
function M.get(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  return lsp_roots(buf)[1] or M.project(buf)
end

return M
