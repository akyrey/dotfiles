local remap = vim.api.nvim_set_keymap
local M = {}

M.config = function ()
  vim.g.coq_settings = {
    auto_start = 'shut-up',
    clients = {
      tabnine = {
        enabled = true,
        short_name = ' ♖  (T9)',
        weight_adjust = -2,
      },
      buffers = {
        short_name = '   (Buffer)',
      },
      tree_sitter = {
        short_name = '   (TS)',
      },
      paths = {
        short_name = '   (Path)',
      },
      snippets = {
        short_name = '   (Snippet)',
      },
      lsp = {
        short_name = '   (LSP)',
        weight_adjust = 2,
      },
    },
    limits = {
      completion_auto_timeout = 0.2
    },
    display = {
      pum = {
        source_context = { '', '' },
      },
      icons = {
        mappings = {
          Text = "",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "ﰠ",
          Variable = "",
          Class = "ﴯ",
          Interface = "",
          Module = "",
          Property = "ﰠ",
          Unit = "塞",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "פּ",
          Event = "",
          Operator = "",
          TypeParameter = ""
        },
      },
    },
    keymap = {
      recommended = false,
    },
  }

  -- these mappings are coq recommended mappings unrelated to nvim-autopairs
  remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
  remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
  remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
  remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })
end

return M
