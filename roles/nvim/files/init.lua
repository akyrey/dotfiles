-- Entry point. Everything this config does starts here, in this order.
require("core.options") -- vim.o / vim.g settings (must run before lazy)
require("core.filetypes") -- custom filetype detection
require("core.keymaps") -- global keymaps (plugin keymaps live in their specs)
require("core.autocmds") -- global autocmds
require("core.lazy") -- bootstrap lazy.nvim and load lua/plugins/*
require("core.lsp") -- diagnostics, LspAttach keymaps, vim.lsp.enable
