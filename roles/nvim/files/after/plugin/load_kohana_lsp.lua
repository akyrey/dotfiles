-- local client = vim.lsp.start({
--   name = "kohana-lsp",
--   cmd = { "/home/akyrey/personal/kohana-lsp/main" },
--   root_dir = vim.fn.getcwd(),
--   on_attach = require("lazyvim.util").lsp.on_attach,
-- })
--
-- if not client then
--   vim.notify("Failed to start kohana-lsp", vim.log.levels.ERROR)
--   return
-- end
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "php" },
--   callback = function()
--     vim.lsp.buf_attach_client(0, client)
--   end,
-- })
