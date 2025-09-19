-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

-- Color line numbers
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#2196f3" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FBC02D" })
  end,
})

-- PHP related autocmds
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    ---@class ParserInfo[]
    local parser_config = require("nvim-treesitter.parsers")
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        query = "queries/blade",
      },
    }
  end,
})

-- Define an autocmd group for the blade workaround
local lsp_blade_workaround = vim.api.nvim_create_augroup("lsp_blade_workaround", { clear = true })
-- Autocommand to temporarily change 'blade' filetype to 'php' when opening for LSP server activation
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = lsp_blade_workaround,
  pattern = "*.blade.php",
  callback = function()
    vim.bo.filetype = "php"
  end,
})

-- Additional autocommand to switch back to 'blade' after LSP has attached
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.blade.php",
  callback = function(args)
    vim.schedule(function()
      -- Check if the attached client is 'intelephense'
      for _, client in ipairs(vim.lsp.get_active_clients()) do
        if client.name == "intelephense" and client.attached_buffers[args.buf] then
          vim.api.nvim_set_option_value("filetype", "blade", { buf = args.buf })
          -- update treesitter parser to blade
          vim.api.nvim_set_option_value("syntax", "blade", { buf = args.buf })
          break
        end
      end
    end)
  end,
})

-- make $ part of the keyword for php.
-- vim.api.nvim_exec2(
--   [[
-- autocmd FileType php set iskeyword+=$
-- ]],
--   { output = false }
-- )
