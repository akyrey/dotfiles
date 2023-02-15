return function()
    local cmd = vim.cmd
    local ok, _ = pcall(require, "catppuccin")
    if ok then
        vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
        vim.g.colors_name = "catppuccin" -- Colorscheme must get called after plugins are loaded or it will break new installs.
        cmd("colorscheme catppuccin")
    end
    cmd("highlight NonText guifg='#2196f3'")

    -- Color line numbers
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#2196f3" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FBC02D" })

    cmd("set termguicolors")

    cmd("hi LspInlayHint guifg=#D8D8D8 guibg=none")

    -- Change cursor shape for all modes
    cmd("set guicursor=n-v-c:block-Cursor-blinkon0")
    cmd("set guicursor+=ve:ver35-Cursor")
    cmd("set guicursor+=o:hor50-Cursor-blinkwait175-blinkoff150-blinkon175")
    cmd("set guicursor+=i-ci:ver20-Cursor")
    cmd("set guicursor+=r-cr:hor20-Cursor")
    cmd("set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175")

    -- Set transparent window
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "MsgArea", { bg = "none" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
end

