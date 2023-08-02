local M = {}

function M.setup()
    local ok, toggleterm = pcall(require, "toggleterm")

    if not ok then
        return
    end

    toggleterm.setup({
        -- size can be a number or function which is passed the current terminal
        size = 20,
        -- open_mapping = [[<c-\>]],
        open_mapping = [[<c-t>]],
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,     -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        persist_size = false,
        -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
        direction = "tab",
        close_on_exit = false, -- close the terminal window when the process exits
        shell = vim.o.shell,   -- change the default shell
        -- This field is only relevant if direction is set to 'float'
        float_opts = {
            -- The border key is *almost* the same as 'nvim_win_open'
            -- see :h nvim_win_open for details on borders however
            -- the 'curved' border is a custom border type
            -- not natively supported but implemented in this plugin.
            -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
            border = "curved",
            -- width = <value>,
            -- height = <value>,
            winblend = 0,
            highlights = {
                border = "Normal",
                background = "Normal",
            },
        },
    })
end

M.lazygit_toggle = function()
    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new {
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
            border = "none",
            width = 100000,
            height = 100000,
        },
        on_open = function(_)
            vim.cmd "startinsert!"
        end,
        on_close = function(_) end,
        count = 99,
    }
    lazygit:toggle()
end

return M
