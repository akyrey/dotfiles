local M = {}

local Log = require "akyrey.core.log"
local fmt = string.format
local akyrey_lsp_utils = require "akyrey.lsp.utils"

function M.init_defaults(languages)
  languages = languages or akyrey_lsp_utils.get_all_supported_filetypes()
  for _, entry in ipairs(languages) do
    if not akyrey.lang[entry] then
      akyrey.lang[entry] = {
        formatters = {},
        linters = {},
        lsp = {},
      }
    end
  end
end

local function resolve_mason_config(server_name)
  local found, mason_config = pcall(require, "mason-lspconfig.server_configurations." .. server_name)
  if not found then
    Log:debug(fmt("mason configuration not found for %s", server_name))
    return {}
  end
  local server_mapping = require "mason-lspconfig.mappings.server"
  local path = require "mason-core.path"
  local pkg_name = server_mapping.lspconfig_to_package[server_name]
  local install_dir = path.package_prefix(pkg_name)
  local conf = mason_config(install_dir)
  Log:debug(fmt("resolved mason configuration for %s, got %s", server_name, vim.inspect(conf)))
  return conf or {}
end

---Resolve the configuration for a server based on both common and user configuration
---@param name string
---@param user_config table [optional]
---@return table
local function resolve_config(server_name, ...)
  local config = {
    on_attach = require("akyrey.lsp").common_on_attach,
    on_init = require("akyrey.lsp").common_on_init,
    on_exit = require("akyrey.lsp").common_on_exit,
    capabilities = require("akyrey.lsp").common_capabilities(),
  }

  local has_custom_provider, custom_config = pcall(require, "akyrey/lsp/providers/" .. server_name)
  if has_custom_provider then
    Log:debug("Using custom configuration for requested server: " .. server_name)
    config = vim.tbl_deep_extend("force", config, custom_config)
  end

  config = vim.tbl_deep_extend("force", config, ...)

  return config
end

-- manually start the server and don't wait for the usual filetype trigger from lspconfig
local function buf_try_add(server_name, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  require("lspconfig")[server_name].manager.try_add_wrapper(bufnr)
end

-- check if the manager autocomd has already been configured since some servers can take a while to initialize
-- this helps guarding against a data-race condition where a server can get configured twice
-- which seems to occur only when attaching to single-files
local function client_is_configured(server_name, ft)
  ft = ft or vim.bo.filetype
  local active_autocmds = vim.api.nvim_get_autocmds { event = "FileType", pattern = ft }
  for _, result in ipairs(active_autocmds) do
    if result.command:match(server_name) then
      Log:debug(string.format("[%q] is already configured", server_name))
      return true
    end
  end
  return false
end

local function launch_server(server_name, config)
  pcall(function()
    require("lspconfig")[server_name].setup(config)
    buf_try_add(server_name)
  end)
end

---Setup a language server by providing a name
---@param server_name string name of the language server
---@param user_config table [optional] when available it will take predence over any default configurations
function M.setup(server_name, user_config)
  vim.validate { name = { server_name, "string" } }
  user_config = user_config or {}

  if akyrey_lsp_utils.is_client_active(server_name) or client_is_configured(server_name) then
    return
  end

  local server_mapping = require "mason-lspconfig.mappings.server"
  local registry = require "mason-registry"

  local pkg_name = server_mapping.lspconfig_to_package[server_name]
  if not pkg_name then
    local config = resolve_config(server_name, user_config)
    launch_server(server_name, config)
    return
  end

  local should_auto_install = function(name)
    local installer_settings = akyrey.lsp.installer.setup
    return installer_settings.automatic_installation
      and not vim.tbl_contains(installer_settings.automatic_installation.exclude, name)
  end

  if not registry.is_installed(pkg_name) then
    if should_auto_install(server_name) then
      Log:debug "Automatic server installation detected"
      vim.notify_once(string.format("Installation in progress for [%s]", server_name), vim.log.levels.INFO)
      local pkg = registry.get_package(pkg_name)
      pkg:install():once("closed", function()
        if pkg:is_installed() then
          vim.schedule(function()
            vim.notify_once(string.format("Installation complete for [%s]", server_name), vim.log.levels.INFO)
            -- mason config is only available once the server has been installed
            local config = resolve_config(server_name, resolve_mason_config(server_name), user_config)
            launch_server(server_name, config)
          end)
        end
      end)
      return
    else
      Log:debug(server_name .. " is not managed by the automatic installer")
    end
  end

  local config = resolve_config(server_name, resolve_mason_config(server_name), user_config)
  launch_server(server_name, config)
end

return M
