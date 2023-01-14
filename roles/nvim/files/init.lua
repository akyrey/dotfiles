--        _
--   __ _| | ___   _ _ __ ___ _   _ 
--  / _` | |/ / | | | '__/ _ \ | | |
-- | (_| |   <| |_| | | |  __/ |_| |
--  \__,_|_|\_\\__, |_|  \___|\__, |
--             |___/          |___/ 
-- 
-- Inspired by https://github.com/tjdevries and https://github.com/ThePrimeagen
--
-- Packer installation if required
if require "akyrey.first_load"() then
  return
end

-- Speed up loading Lua modules in Neovim to improve startup time
--  using pcall here to avoid errors when no plugin is installed
pcall(require, "impatient")

-- General keymaps not related to a single plugin
require("akyrey.keymaps")

-- General settings
require("akyrey.settings")()

-- Must be called after plugin installations
require("akyrey.theme")()

-- Turn off builtin plugins I do not use.
require("akyrey.disable_builtin")()

-- Manage plugins with Packer
require("akyrey.plugins")

-- Setup auto commands
require("akyrey.auto_commands")

-- Setup lsp
require("akyrey.lsp")
