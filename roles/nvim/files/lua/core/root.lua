-- Project root detection, ported from LazyVim's util.root.
--
-- Resolution order comes from `vim.g.root_spec`; the first detector that returns
-- a directory wins. Used by pickers and by anything that needs "the project"
-- rather than the cwd.
local M = {}

---@alias RootFn fun(buf: integer): string[]

---@type table<string, RootFn>
M.detectors = {}

function M.detectors.cwd()
  return { vim.uv.cwd() }
end

--- Roots reported by any LSP client attached to the buffer.
function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then
    return {}
  end
  local roots = {} ---@type string[]
  local ignore = vim.g.root_lsp_ignore or {}
  for _, client in pairs(vim.lsp.get_clients({ bufnr = buf })) do
    if not vim.tbl_contains(ignore, client.name) then
      for _, ws in pairs(client.config.workspace_folders or {}) do
        roots[#roots + 1] = vim.uri_to_fname(ws.uri)
      end
      if client.root_dir then
        roots[#roots + 1] = client.root_dir
      end
    end
  end
  return vim.tbl_filter(function(path)
    path = M.norm(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

--- Roots found by walking up looking for marker files/directories.
---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.uv.cwd()
  local pattern = vim.fs.find(function(name)
    for _, p in ipairs(patterns) do
      if name == p or (p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$")) then
        return true
      end
    end
    return false
  end, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.bufpath(buf)
  return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

function M.realpath(path)
  if path == "" or path == nil then
    return nil
  end
  path = vim.uv.fs_realpath(path) or path
  return M.norm(path)
end

function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

---@param spec string|string[]|RootFn
---@return RootFn
local function resolve(spec)
  if M.detectors[spec] then
    return M.detectors[spec]
  elseif type(spec) == "function" then
    return spec
  end
  return function(buf)
    return M.detectors.pattern(buf, spec)
  end
end

--- All candidate roots for a buffer, best first.
---@param opts? { buf?: integer }
function M.detect(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = {} ---@type string[]
  for _, spec in ipairs(vim.g.root_spec or { "lsp", { ".git", "lua" }, "cwd" }) do
    local paths = resolve(spec)(buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(ret, pp) then
        ret[#ret + 1] = pp
      end
    end
    if #ret > 0 then
      break
    end
  end
  return ret
end

--- The project root for a buffer, falling back to cwd.
---@param buf? integer
---@return string
function M.get(buf)
  return M.detect({ buf = buf })[1] or vim.uv.cwd()
end

return M
