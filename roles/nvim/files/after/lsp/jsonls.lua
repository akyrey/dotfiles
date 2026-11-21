-- Overrides on top of nvim-lspconfig's lsp/jsonls.lua.
return {
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
