local M = {}

M.setup = function()
    local ok, indent_blankline = pcall(require, "ibl")

    if not ok then
        return
    end

    indent_blankline.setup({
        exclude = {
            filetypes = {
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
        },
        scope = {
            show_end = false,
            show_start = false,
        },
    })
end

return M
