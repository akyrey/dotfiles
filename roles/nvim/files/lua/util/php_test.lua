-- Runs neotest's PHP adapters (pest, phpunit) inside each project's container.
--
-- Every work project defines a `php` command in its projector config that knows
-- how to reach that project's PHP: `./xenv php`, `./xenv run php`, or a
-- throwaway `docker run`. Routing tests through it keeps the per-project
-- docker details in one place instead of mirroring them here.
--
-- The adapters build commands with absolute host paths, which do not exist in
-- the container. This wrapper rewrites the spec they produce:
--   * paths under the project root become root-relative, and the command runs
--     from the root, which is also the container's working directory;
--   * the JUnit report goes to vendor/, which every composer project has,
--     is gitignored, and is bind-mounted so the host can read it back;
--   * container paths in the report are mapped back to host paths.
-- Projects without a projector `php` command run the tools directly.
local M = {}

local ROOT_MARKERS = { "composer.json" }
local PROJECTOR_COMMAND = "php"
local REPORT_DIR = "vendor"

---@type table<string, boolean>
local projector_php_by_root = {}

--- Whether projector defines a `php` command for this project. Uses cobra's
--- completion endpoint, which prints one command name per line. Cached per root.
---@param root string
---@return boolean
local function has_projector_php(root)
  if projector_php_by_root[root] ~= nil then
    return projector_php_by_root[root]
  end
  local found = false
  if vim.fn.executable("projector") == 1 then
    local result = vim.system({ "projector", "__complete", "run", "" }, { cwd = root, text = true }):wait()
    if result.code == 0 then
      for line in vim.gsplit(result.stdout or "", "\n", { plain = true }) do
        if line:match("^[^\t]+") == PROJECTOR_COMMAND then
          found = true
          break
        end
      end
    end
  end
  projector_php_by_root[root] = found
  return found
end

---@param root string
---@param arg string
---@return string
local function relative(root, arg)
  -- Only absolute paths: relpath resolves anything else against the cwd.
  if not vim.startswith(arg, "/") then
    return arg
  end
  return vim.fs.relpath(root, arg) or arg
end

--- Pest filters are regexes matched against test descriptions, which contain
--- spaces and punctuation. Swapping every such character for `.` keeps the
--- match while leaving nothing for a shell or wrapper script to mangle.
---@param filter string
---@return string
local function shell_safe_filter(filter)
  return (filter:gsub("[^%w_]", "."))
end

---@param spec neotest.RunSpec
---@param root string
---@param opts { loose_filter: boolean }
---@return string[] args, string report
local function rewrite_args(spec, root, opts)
  local report = string.format("%s/.neotest-%d-%d.xml", REPORT_DIR, os.time(), math.random(1e9))
  local args = {}
  local previous
  for _, arg in ipairs(spec.command) do
    -- neotest-phpunit leaves `false` in place of the path when running a suite.
    if type(arg) == "string" then
      local rewritten
      if vim.startswith(arg, "--log-junit=") then
        rewritten = "--log-junit=" .. report
      elseif previous == "--filter" and opts.loose_filter then
        rewritten = shell_safe_filter(arg)
      else
        rewritten = relative(root, arg)
      end
      table.insert(args, rewritten)
      previous = arg
    end
  end
  return args, report
end

--- Map a path reported from inside the container back onto the host by
--- dropping leading segments until the remainder exists under the root:
--- /var/www/html/tests/unit/FooTest.php -> <root>/tests/unit/FooTest.php.
---@param root string
---@param path string
---@return string
local function host_path(root, path)
  if vim.startswith(path, root .. "/") or not vim.startswith(path, "/") then
    return path
  end
  local tail = path
  while tail do
    local candidate = root .. tail
    if vim.uv.fs_stat(candidate) then
      return candidate
    end
    tail = tail:match("^/[^/]+(/.+)$")
  end
  return path
end

---@param results table<string, neotest.Result>
---@param root string
---@return table<string, neotest.Result>
local function remap_result_ids(results, root)
  local remapped = {}
  for id, result in pairs(results) do
    local path, rest = id:match("^(.-)(::.*)$")
    remapped[path and (host_path(root, path) .. rest) or id] = result
  end
  return remapped
end

--- Wrap a neotest adapter so its tests run through projector.
---@param adapter neotest.Adapter
---@param opts? { loose_filter?: boolean } loose_filter: make --filter values shell-safe (pest)
---@return neotest.Adapter
function M.wrap(adapter, opts)
  opts = { loose_filter = (opts or {}).loose_filter == true }
  local wrapped = setmetatable({}, { __index = adapter })

  function wrapped.build_spec(args)
    local spec = adapter.build_spec(args)
    local root = spec and vim.fs.root(args.tree:data().path, ROOT_MARKERS)
    -- The dap strategy launches its own program; leave it untouched.
    if not root or args.strategy == "dap" then
      return spec
    end

    local cmd_args, report = rewrite_args(spec, root, opts)
    if has_projector_php(root) then
      local quoted = vim.tbl_map(vim.fn.shellescape, cmd_args)
      spec.command = vim.list_extend({ "projector", "run", PROJECTOR_COMMAND, "--" }, quoted)
    else
      spec.command = cmd_args
    end
    spec.cwd = root
    spec.context = vim.tbl_extend("force", spec.context or {}, {
      results_path = vim.fs.joinpath(root, report),
      project_root = root,
    })
    return spec
  end

  function wrapped.results(spec, result, tree)
    local ok, results = pcall(adapter.results, spec, result, tree)
    if spec.context and spec.context.project_root then
      os.remove(spec.context.results_path)
    end
    if not ok then
      error(results)
    end
    if spec.context and spec.context.project_root then
      return remap_result_ids(results, spec.context.project_root)
    end
    return results
  end

  return wrapped
end

return M
