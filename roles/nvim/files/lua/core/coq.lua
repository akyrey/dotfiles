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
  }
end

return M
