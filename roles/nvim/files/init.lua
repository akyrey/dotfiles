local init_path = debug.getinfo(1, "S").source:sub(2)
local base_dir = init_path:match("(.*[/\\])"):sub(1, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end

require("akyrey.bootstrap"):init(base_dir)

require("akyrey.config"):load()

local plugins = require "akyrey.plugins"
require("akyrey.plugin-loader"):load { plugins, akyrey.plugins }

local Log = require "akyrey.core.log"
Log:debug "Starting Aky NeoVim"

require("akyrey.theme").setup() -- Colorscheme must get called after plugins are loaded or it will break new installs.

local commands = require "akyrey.core.commands"
commands.load(commands.defaults)

require("akyrey.keymappings").setup()

require("akyrey.lsp").setup()
