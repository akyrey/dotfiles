local M = {}

local Log = require "akyrey.core.log"
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

---Resolve the configuration for a server based on both common and user configuration
---@param name string
---@param user_config table [optional]
---@return table
local function resolve_config(name, user_config)
  local config = {
    on_attach = require("akyrey.lsp").common_on_attach,
    on_init = require("akyrey.lsp").common_on_init,
    on_exit = require("akyrey.lsp").common_on_exit,
    capabilities = require("akyrey.lsp").common_capabilities(),
  }

  local has_custom_provider, custom_config = pcall(require, "akyrey/lsp/providers/" .. name)
  if has_custom_provider then
    Log:debug("Using custom configuration for requested server: " .. name)
    config = vim.tbl_deep_extend("force", config, custom_config)
  end

  if user_config then
    config = vim.tbl_deep_extend("force", config, user_config)
  end

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
  local active_autocmds = vim.split(vim.fn.execute("autocmd FileType " .. ft), "\n")
  for _, result in ipairs(active_autocmds) do
    if result:match(server_name) then
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

  local servers = require "nvim-lsp-installer.servers"
  local server_available, server = servers.get_server(server_name)

  if not server_available then
    local config = resolve_config(server_name, user_config)
    launch_server(server_name, config)
    return
  end

  local install_in_progress = false

  if not server:is_installed() then
    if akyrey.lsp.automatic_servers_installation then
      Log:debug "Automatic server installation detected"
      server:install()
      install_in_progress = true
    else
      Log:debug(server.name .. " is not managed by the automatic installer")
    end
  end

  server:on_ready(function()
    if install_in_progress then
      vim.notify(string.format("Installation complete for [%s] server", server.name), vim.log.levels.INFO)
    end
    install_in_progress = false
    local config = resolve_config(server_name, server:get_default_options(), user_config)
    launch_server(server_name, config)
  end)
end

return M
