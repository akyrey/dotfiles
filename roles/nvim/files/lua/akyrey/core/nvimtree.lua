local M = {}
local Log = require "akyrey.core.log"

M.config = function()
  akyrey.builtin.nvimtree = {
    active = true,
    on_config_done = nil,
    before_setup = {
      quit_on_open = 0,
      indent_markers = 1,
      git_hl = 1,
      highlight_opened_files = 1,
      root_folder_modifier = ":t",
      add_trailing = 1,
      group_empty = 0,
      disable_window_picker = 0,
      icon_padding = ' ',
      symlink_arrow = ' ➛ ',
      respect_buf_cwd = 0,
      create_in_closed_folder = 1,
      refresh_wait = 1000,
      show_icons = {
        git = 1,
        folders = 1,
        files = 1,
        folder_arrows = 1,
        tree_width = 30,
      },
      icons = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      },
    },
    setup = {
      open_on_setup = false,
      auto_close = true,
      open_on_tab = false,
      hide_dotfiles = 1,
      update_focused_file = {
        enable = true,
      },
      diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      git = {
        enable = true,
      },
      filters = {
        custom = { ".git", "node_modules", ".cache" },
      },
      view = {
        width = 30,
        side = "left",
        auto_resize = true,
        mappings = {
          custom_only = false,
        },
      },
    },
  }
end

M.setup = function()
  local status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
  if not status_ok then
    Log:error "Failed to load nvim-tree.config"
    return
  end
  local g = vim.g

  for opt, val in pairs(akyrey.builtin.nvimtree.before_setup) do
    g["nvim_tree_" .. opt] = val
  end

  local tree_cb = nvim_tree_config.nvim_tree_callback

  if not akyrey.builtin.nvimtree.setup.view.mappings.list then
    akyrey.builtin.nvimtree.setup.view.mappings.list = {
      { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
      { key = "h", cb = tree_cb "close_node" },
      { key = "v", cb = tree_cb "vsplit" },
    }
  end

  akyrey.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" }

  local tree_view = require "nvim-tree.view"

  -- Add nvim_tree open callback
  local open = tree_view.open
  tree_view.open = function()
    M.on_open()
    open()
  end

  vim.cmd "au WinClosed * lua require('akyrey.core.nvimtree').on_close()"

  if akyrey.builtin.nvimtree.on_config_done then
    akyrey.builtin.nvimtree.on_config_done(nvim_tree_config)
  end
  require("nvim-tree").setup(akyrey.builtin.nvimtree.setup)
end

function M.on_open()
  if package.loaded["bufferline.state"] and akyrey.builtin.nvimtree.setup.view.side == "left" then
    require("bufferline.state").set_offset(akyrey.builtin.nvimtree.setup.view.width + 1, "")
  end
end

function M.on_close()
  local buf = tonumber(vim.fn.expand "<abuf>")
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  if ft == "NvimTree" and package.loaded["bufferline.state"] then
    require("bufferline.state").set_offset(0)
  end
end

function M.change_tree_dir(dir)
  local lib_status_ok, lib = pcall(require, "nvim-tree.lib")
  if lib_status_ok then
    lib.change_dir(dir)
  end
end

return M
