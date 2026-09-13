-- Resolving PHP tooling (pint, php-cs-fixer, phpcs, phpstan) is fiddly because
-- it may live in a docker wrapper, a project's vendor dir, or on $PATH.
--
-- The old config had two copies of this logic that had drifted apart: one
-- resolved paths relative to the project root, the other relative to the cwd,
-- and they disagreed about how to invoke xenv. This is the reconciled version,
-- always root-relative, and it is the only copy.
local M = {}

local ROOT_MARKERS = { "composer.json", ".git" }

--- Project root for a buffer. Always pass the buffer being acted on: conform
--- can format a buffer that is not the current one, and resolving against the
--- wrong buffer picks up the wrong project's vendor/ and xenv.
---@param bufnr integer?
---@return string
local function project_root(bufnr)
  return vim.fs.root(bufnr or 0, ROOT_MARKERS) or vim.uv.cwd()
end

--- Resolve how to run a PHP tool, in order of preference:
---   1. <root>/dev/bin/<exe>        project's own docker wrapper script
---   2. <root>/xenv <exe>           skp docker environment wrapper
---   3. <root>/vendor/bin/sail <exe>  laravel sail
---   4. <root>/vendor/bin/<exe>     composer-installed binary
---   5. <exe>                       whatever is on $PATH
---
--- Wrappers (xenv, sail) take the tool name as their first argument, so those
--- are returned in `args` for the caller to prepend.
---@param exe string
---@param bufnr integer?
---@return { cmd: string, args: string[] }
function M.php_tool(exe, bufnr)
  local root = project_root(bufnr)

  local dev_bin = vim.fs.joinpath(root, "dev", "bin", exe)
  if vim.uv.fs_stat(dev_bin) then
    return { cmd = dev_bin, args = {} }
  end

  local xenv = vim.fs.joinpath(root, "xenv")
  if vim.fn.executable(xenv) == 1 then
    return { cmd = xenv, args = { exe } }
  end

  local sail = vim.fs.joinpath(root, "vendor", "bin", "sail")
  if vim.fn.executable(sail) == 1 then
    return { cmd = sail, args = { exe } }
  end

  local vendor = vim.fs.joinpath(root, "vendor", "bin", exe)
  if vim.fn.executable(vendor) == 1 then
    return { cmd = vendor, args = {} }
  end

  return { cmd = exe, args = {} }
end

--- True when composer.json requires laravel/pint, in either require section.
--- Used to pick pint over php-cs-fixer per project.
---@param bufnr integer?
---@return boolean
function M.has_pint(bufnr)
  local composer = vim.fs.joinpath(project_root(bufnr), "composer.json")
  local fd = io.open(composer, "r")
  if not fd then
    return false
  end
  local content = fd:read("*a")
  fd:close()
  if not content then
    return false
  end
  local ok, json = pcall(vim.json.decode, content)
  if not ok or type(json) ~= "table" then
    return false
  end
  local req = json["require"] or {}
  local req_dev = json["require-dev"] or {}
  return (req["laravel/pint"] or req_dev["laravel/pint"]) ~= nil
end

M.project_root = project_root

return M
