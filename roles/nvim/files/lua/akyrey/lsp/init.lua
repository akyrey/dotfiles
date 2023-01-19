-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")
local lsp_config = require("akyrey.lsp.config")

require("akyrey.lsp.handlers").setup()

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(lsp_config.servers),
}

mason_lspconfig.setup_handlers(lsp_config.handlers)
