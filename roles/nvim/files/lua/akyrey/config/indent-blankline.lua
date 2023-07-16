local M = {}

M.setup = function()
    local ok, indent_blankline = pcall(require, "indent_blankline")

    if not ok then
        return
    end

    indent_blankline.setup({
        char = "│",
        filetype_exclude = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
        },
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = false,
        use_treesitter = true,
        use_treesitter_scope = true,
    })
end

return M
