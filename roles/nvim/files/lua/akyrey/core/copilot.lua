local M = {}

function M.config()
    akyrey.builtin.copilot = {
        cmp = {
            enabled = true,
            method = "getPanelCompletions",
        },
        panel = { -- no config options yet
            enabled = true,
        },
        ft_disable = {},
        plugin_manager_path = vim.fn.stdpath("data") .. "/site/pack/packer",
        server_opts_overrides = {},
    }
end

M.setup = function()
    vim.defer_fn(function()
        require("copilot").setup(akyrey.builtin.copilot)
    end, 100)
end

return M
