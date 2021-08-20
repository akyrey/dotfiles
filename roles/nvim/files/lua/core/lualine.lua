local M = {}
local Log = require "core.log"
-- Color table for highlights
local colors = {
  bg = '#202328',
  fg = '#bbc2cf',
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67'
}

local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end
}

M.config = function()
  akyrey.builtin.lualine = {
    options = {
      theme = 'gruvbox',
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch'},
      lualine_c = {
        'filename',
        {
          -- Lsp server name .
          function()
            local msg = 'No Active Lsp'
            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then return msg end
            for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
              end
            end
            return msg
          end,
          icon = ' LSP:',
          color = {fg = '#ffffff', gui = 'bold'}
        },
        {
          'diagnostics',
          sources = {'nvim_lsp'},
          symbols = {error = ' ', warn = ' ', info = ' '},
          color_error = colors.red,
          color_warn = colors.yellow,
          color_info = colors.cyan
        },
      },
      lualine_x = {
        {
          'diff',
          -- Is it me or the symbol for modified us really weird
          symbols = {added = ' ', modified = '柳 ', removed = ' '},
          color_added = colors.green,
          color_modified = colors.orange,
          color_removed = colors.red,
          condition = conditions.hide_in_width
        },
        'encoding',
        'fileformat',
        'filetype',
      },
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = { 'fugitive', 'quickfix', 'nvim-tree' },
  }
end

M.setup = function()
  local status_ok, lualine = pcall(require, "lualine")
  if not status_ok then
    Log:get_default().error "failed to load lualine"
    return
  end

  lualine.setup(akyrey.builtin.lualine)
end

return M
