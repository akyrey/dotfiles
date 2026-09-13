local lsp = require("util.lsp")

return {
  cmd = lsp.node_cmd("vscode-json-language-server"),
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  before_init = function(_, new_config)
    new_config.settings.json.schemas =
      vim.list_extend(new_config.settings.json.schemas or {}, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      format = { enable = true },
      validate = { enable = true },
    },
  },
}
