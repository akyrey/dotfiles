require "config"
local autocmds = require "core.autocmds"
require("settings").unload_default_plugins()
require("settings").load_options()
require("settings").load_commands()
autocmds.define_augroups(akyrey.autocommands)

local plugins = require "plugins"
local plugin_loader = require("plugin-loader").init()
plugin_loader:load { plugins, akyrey.plugins }
require("theme").setup()

local utils = require "utils"
utils.toggle_autoformat()
local commands = require "core.commands"
commands.load(commands.defaults)

require("lsp").config()

local null_status_ok, null_ls = pcall(require, "null-ls")
if null_status_ok then
  null_ls.config {}
  require("lspconfig")["null-ls"].setup {}
end

local lsp_settings_status_ok, lsp_settings = pcall(require, "nlspsettings")
if lsp_settings_status_ok then
  lsp_settings.setup {
    config_home = os.getenv "HOME" .. "/.config/nvim/lsp-settings",
  }
end

require("keymappings").setup()

-- TODO: these guys need to be in language files
-- if nvim.lang.emmet.active then
--   require "lsp.emmet-ls"
-- end
-- if nvim.lang.tailwindcss.active then
--   require "lsp.tailwind

