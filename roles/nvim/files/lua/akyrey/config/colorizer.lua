local M = {}

M.setup = function()
    local ok, colorizer = pcall(require, "colorizer")

    if not ok then
        return
    end

    colorizer.setup({
        '*'; -- Highlight all files, but customize some others.
        css = { rgb_fn = true; }; -- Enable parsing rgb(...) functions in css.
    })
end

return M
