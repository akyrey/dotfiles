local utils = require "akyrey.utils"
local Log = require "akyrey.core.log"
local autocmds = require "akyrey.core.autocmds"

local M = {}
local user_config_dir = get_config_dir()
local user_config_file = utils.join_paths(user_config_dir, "akyrey.config.lua")

---Get the full path to the user configuration file
---@return string
function M:get_user_config_path()
  return user_config_file
end

--- Initialize akyrey default configuration
-- Define akyrey global variable
function M:init()
  if vim.tbl_isempty(akyrey or {}) then
    akyrey = require "akyrey.config.defaults"
    local home_dir = vim.loop.os_homedir()
    akyrey.vsnip_dir = utils.join_paths(home_dir, ".config", "snippets")
    akyrey.database = { save_location = utils.join_paths(home_dir, ".config", "akyreyvim_db"), auto_execute = 1 }
  end

  local builtins = require "akyrey.core.builtins"
  builtins.config { user_config_file = user_config_file }

  local settings = require "akyrey.config.settings"
  settings.load_options()

  local autocmds = require "akyrey.core.autocmds"
  akyrey.autocommands = autocmds.load_augroups()

  local akyrey_lsp_config = require "akyrey.lsp.config"
  akyrey.lsp = vim.deepcopy(akyrey_lsp_config)

  local supported_languages = require "akyrey.config.supported_languages"
  require("akyrey.lsp.manager").init_defaults(supported_languages)
end

--- Override the configuration with a user provided one
-- @param config_path The path to the configuration overrides
function M:load(config_path)
  local autocmds = require "akyrey.core.autocmds"
  config_path = config_path or self.get_user_config_path()
  local ok, err = pcall(dofile, config_path)
  if not ok then
    if utils.is_file(user_config_file) then
      Log:warn("Invalid configuration: " .. err)
    else
      Log:warn(string.format("Unable to find configuration file [%s]", config_path))
    end
  end

  autocmds.define_augroups(akyrey.autocommands)

  local settings = require "akyrey.config.settings"
  settings.load_commands()
end

--- Override the configuration with a user provided one
-- @param config_path The path to the configuration overrides
function M:reload()
  local akyrey_modules = {}
  for module, _ in pairs(package.loaded) do
    if module:match "akyrey" then
      package.loaded.module = nil
      table.insert(akyrey_modules, module)
    end
  end

  M:init()
  M:load()

  require("akyrey.keymappings").setup() -- this should be done before loading the plugins
  local plugins = require "akyrey.plugins"
  autocmds.toggle_autoformat()
  local plugin_loader = require "akyrey.plugin-loader"
  plugin_loader:cache_reset()
  plugin_loader:load { plugins, akyrey.plugins }
  vim.cmd ":PackerInstall"
  vim.cmd ":PackerCompile"
  -- vim.cmd ":PackerClean"
  require("akyrey.lsp").setup()
  Log:info "Reloaded configuration"
end

return M

