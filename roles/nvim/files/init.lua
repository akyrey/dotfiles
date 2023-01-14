--        _
--   __ _| | ___   _ _ __ ___ _   _ 
--  / _` | |/ / | | | '__/ _ \ | | |
-- | (_| |   <| |_| | | |  __/ |_| |
--  \__,_|_|\_\\__, |_|  \___|\__, |
--             |___/          |___/ 
-- 
-- Inspired by https://github.com/tjdevries and https://github.com/ThePrimeagen
--

-- Speed up loading Lua modules in Neovim to improve startup time
--  using pcall here to avoid errors when no plugin is installed
pcall(require, "impatient")

-- General keymaps not related to a single plugin
require("akyrey.keymaps")

-- General settings
require("akyrey.settings")()

-- Turn off builtin plugins I do not use.
require("akyrey.disable_builtin")()

-- Manage plugins with Lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("akyrey.plugins", {
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
    },
  },
})

-- Must be called after plugin installations
require("akyrey.theme")()

-- Setup auto commands
require("akyrey.auto_commands")

-- Setup lsp
require("akyrey.lsp")
