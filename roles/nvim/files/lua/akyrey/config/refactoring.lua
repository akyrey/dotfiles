local M = {}

M.setup = function()
    local ok, refactoring = pcall(require, "refactoring")

    if not ok then
        return
    end

    refactoring.setup({})
end

return M
