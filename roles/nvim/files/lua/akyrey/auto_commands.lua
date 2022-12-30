-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    command = "source <afile> | PackerSync",
    group = packer_group,
    pattern = vim.fn.expand("~") .. "/.config/nvim/lua/akyrey/plugins.lua",
})

-- Cursorline highlighting control
--  Only have it on in the active buffer
local cursor_group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
    vim.api.nvim_create_autocmd(event, {
        group = cursor_group,
        pattern = pattern,
        callback = function()
            vim.opt_local.cursorline = value
        end,
    })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

-- Format on save
-- local format_on_save_group = vim.api.nvim_create_augroup("FormatOnSave", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     callback = function()
--         local utils = require("akyrey.lsp.utils")
--         utils.format({ timeout_ms = 1000 })
--     end,
--     group = format_on_save_group,
--     pattern = "*",
-- })
