local lsp = require("util.lsp")

return {
  cmd = lsp.node_cmd("yaml-language-server"),
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.ansible" },
  root_markers = { ".git" },
  -- Pull the schema catalog from SchemaStore.nvim rather than letting the
  -- server fetch it over the network.
  before_init = function(_, new_config)
    new_config.settings.yaml.schemas =
      vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = { enable = true },
      validate = true,
      schemaStore = {
        -- SchemaStore.nvim supplies the catalog, so the built-in one is off.
        enable = false,
        url = "",
      },
    },
  },
}
