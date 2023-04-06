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
    pattern = "*/lua/akyrey/plugins.lua",
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

local git_group = vim.api.nvim_create_augroup("GitGroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = git_group,
    pattern = "gitcommit,markdown",
    callback = function()
        vim.cmd "setlocal wrap"
        vim.cmd "setlocal spell"
    end,
})

local inlayHints = vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
    group = inlayHints,
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp-inlayhints").on_attach(client, bufnr)
    end,
})

local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
    group = prefetch,
    pattern = "*.py",
    callback = function()
        require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
    end
})

-- Toggle quickfix listb
vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]]
