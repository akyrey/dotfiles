-- Overrides on top of nvim-lspconfig's lsp/yamlls.lua.
return {
  -- Also attach to ansible files, alongside ansiblels.
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.ansible" },
  -- Pull the schema catalog from SchemaStore.nvim rather than letting the
  -- server fetch it over the network.
  before_init = function(_, new_config)
    new_config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  settings = {
    yaml = {
      keyOrdering = false,
      validate = true,
      schemaStore = {
        -- SchemaStore.nvim supplies the catalog, so the built-in one is off.
        enable = false,
        url = "",
      },
    },
  },
}
