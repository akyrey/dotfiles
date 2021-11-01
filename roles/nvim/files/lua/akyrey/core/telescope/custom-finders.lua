local M = {}

local _, builtin = pcall(require, "telescope.builtin")
local _, finders = pcall(require, "telescope.finders")
local _, pickers = pcall(require, "telescope.pickers")
local _, sorters = pcall(require, "telescope.sorters")
local _, themes = pcall(require, "telescope.themes")
local _, actions = pcall(require, "telescope.actions")
local _, previewers = pcall(require, "telescope.previewers")
local _, make_entry = pcall(require, "telescope.make_entry")

local utils = require "akyrey.utils"

M.find_config_files = function(opts)
  opts = opts or {}
  local themes = require "telescope.themes"
  local theme_opts = themes.get_dropdown {
    sorting_strategy = "ascending",
    prompt = ">> ",
    prompt_title = "~ Config files ~",
    cwd = "~/.config/nvim",
    find_command = { "git", "ls-files" },
  }
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  require("telescope.builtin").find_files(opts)
end

M.grep_config_files = function(opts)
  opts = opts or {}
  local themes = require "telescope.themes"
  local theme_opts = themes.get_dropdown {
    sorting_strategy = "ascending",
    prompt = ">> ",
    prompt_title = "~ search Config ~",
    cwd = "~/.config/nvim",
  }
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  require("telescope.builtin").live_grep(opts)
end

return M
