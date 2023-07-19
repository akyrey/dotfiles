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

local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
    group = prefetch,
    pattern = "*.py",
    callback = function()
        require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
    end
})

-- Automatically open nvim_tree when nvim is opened on a directory
-- local function open_nvim_tree(data)
--     -- buffer is a directory
--     local directory = vim.fn.isdirectory(data.file) == 1
--
--     if not directory then
--         return
--     end
--
--     -- create a new, empty buffer
--     vim.cmd.enew()
--     -- wipe the directory buffer
--     vim.cmd.bw(data.buf)
--     -- change to the directory
--     vim.cmd.cd(data.file)
--     -- open the tree
--     require("nvim-tree.api").tree.open()
-- end
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Automatically open Telescope when nvim is opened on a directory
-- Set current folder as prompt title
local dropdown = require('telescope.themes').get_dropdown({
    hidden = false,
    no_ignore = false,
    previewer = false,
    prompt_title = '',
    preview_title = '',
    results_title = '',
    layout_config = { prompt_position = 'top' },
})
local with_title = function(opts, extra)
    extra = extra or {}
    local path = opts.cwd or opts.path or extra.cwd or extra.path or nil
    local title = ''
    local buf_path = vim.fn.expand('%:p:h')
    local cwd = vim.fn.getcwd()
    if path ~= nil and buf_path ~= cwd then
        title = require('plenary.path'):new(buf_path):make_relative(cwd)
    else
        title = vim.fn.fnamemodify(cwd, ':t')
    end

    return vim.tbl_extend('force', opts, {
        prompt_title = title
    }, extra or {})
end
vim.api.nvim_create_augroup('startup', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
    group = 'startup',
    pattern = '*',
    callback = function()
        -- Open file browser if argument is a folder
        local arg = vim.api.nvim_eval('argv(0)')
        if arg and (vim.fn.isdirectory(arg) ~= 0 or arg == "") then
            vim.defer_fn(function()
                require('telescope.builtin').find_files(with_title(dropdown))
            end, 10)
        end
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
