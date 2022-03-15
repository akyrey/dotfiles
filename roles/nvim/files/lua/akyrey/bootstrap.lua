local M = {}

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

---Get the full path to `$akyreyVIM_RUNTIME_DIR`
---@return string
function _G.get_runtime_dir()
  local akyrey_runtime_dir = os.getenv "AKYREYVIM_RUNTIME_DIR"
  if not akyrey_runtime_dir then
    -- when nvim is used directly
    return vim.fn.stdpath "data"
  end
  return akyrey_runtime_dir
end

---Get the full path to `$akyreyVIM_CONFIG_DIR`
---@return string
function _G.get_config_dir()
  local akyrey_config_dir = os.getenv "AKYREYVIM_CONFIG_DIR"
  if not akyrey_config_dir then
    return vim.fn.stdpath "config"
  end
  return akyrey_config_dir
end

---Get the full path to `$akyreyVIM_CACHE_DIR`
---@return string
function _G.get_cache_dir()
  local akyrey_cache_dir = os.getenv "AKYREYVIM_CACHE_DIR"
  if not akyrey_cache_dir then
    return vim.fn.stdpath "cache"
  end
  return akyrey_cache_dir
end

---Initialize the `&runtimepath` variables and prepare for startup
---@return table
function M:init(base_dir)
  self.runtime_dir = get_runtime_dir()
  self.config_dir = get_config_dir()
  self.cache_path = get_cache_dir()
  self.pack_dir = join_paths(self.runtime_dir, "site", "pack")
  self.packer_install_dir = join_paths(self.runtime_dir, "site", "pack", "packer", "start", "packer.nvim")
  self.packer_cache_path = join_paths(self.config_dir, "plugin", "packer_compiled.lua")

  ---Get the full path to akyreyVim's base directory
  ---@return string
  function _G.get_akyrey_base_dir()
    return base_dir
  end

  if os.getenv "AKYREYVIM_RUNTIME_DIR" then
    -- vim.opt.rtp:append(os.getenv "AKYREYVIM_RUNTIME_DIR" .. path_sep .. "akyrey")
    vim.opt.rtp:remove(join_paths(vim.fn.stdpath "data", "site"))
    vim.opt.rtp:remove(join_paths(vim.fn.stdpath "data", "site", "after"))
    vim.opt.rtp:prepend(join_paths(self.runtime_dir, "site"))
    vim.opt.rtp:append(join_paths(self.runtime_dir, "site", "after"))

    vim.opt.rtp:remove(vim.fn.stdpath "config")
    vim.opt.rtp:remove(join_paths(vim.fn.stdpath "config", "after"))
    vim.opt.rtp:prepend(self.config_dir)
    vim.opt.rtp:append(join_paths(self.config_dir, "after"))
    -- TODO: we need something like this: vim.opt.packpath = vim.opt.rtp

    vim.cmd [[let &packpath = &runtimepath]]
    vim.cmd("set spellfile=" .. join_paths(self.config_dir, "spell", "en.utf-8.add"))
  end

  vim.fn.mkdir(get_cache_dir(), "p")

  -- FIXME: currently unreliable in unit-tests
  if not os.getenv "AKYREY_TEST_ENV" then
    _G.PLENARY_DEBUG = false
    require("akyrey.impatient").setup {
      path = vim.fn.stdpath "cache" .. "/akyrey_cache",
      enable_profiling = true,
    }
  end

  require("akyrey.config"):init()

  require("akyrey.plugin-loader"):init {
    package_root = self.pack_dir,
    install_path = self.packer_install_dir,
  }

  return self
end

local function git_cmd(subcmd, opts)
  local Job = require "plenary.job"
  local Log = require "akyrey.core.log"
  local args = { "-C", opts.cwd }
  vim.list_extend(args, subcmd)

  local stderr = {}
  local stdout, ret = Job
    :new({
      command = "git",
      args = args,
      cwd = opts.cwd,
      on_stderr = function(_, data)
        table.insert(stderr, data)
      end,
    })
    :sync()

  if not vim.tbl_isempty(stderr) then
    Log:debug(stderr)
  end

  if not vim.tbl_isempty(stdout) then
    Log:debug(stdout)
  end

  return ret, stdout
end

return M

