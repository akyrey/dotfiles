local M = {}

function M.config()
  akyrey.builtin.package_info = {
    active = true,
    on_config_done = nil,
    options = {
    colors = {
            up_to_date = "#3C4048", -- Text color for up to date package virtual text
            outdated = "#d19a66", -- Text color for outdated package virtual text
        },
        icons = {
            enable = true, -- Whether to display icons
            style = {
                up_to_date = "|  ", -- Icon for up to date packages
                outdated = "|  ", -- Icon for outdated packages
            },
        },
        autostart = true, -- Whether to autostart when `package.json` is opened
        hide_up_to_date = true, -- It hides up to date versions when displaying virtual text
        hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
        -- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
        -- The plugin will try to auto-detect the package manager based on
        -- `yarn.lock` or `package-lock.json`. If none are found it will use the
        -- provided one, if nothing is provided it will use `yarn`
        package_manager = "npm"
    }
  }
end

function M.setup()
    local package_info = require "package-info"

    package_info.setup(akyrey.builtin.package_info.options)

    -- Show package versions
    vim.api.nvim_set_keymap("n", "<leader>is", ":lua require('package-info').show()<CR>", { silent = true, noremap = true })
    -- Hide package versionj
    vim.api.nvim_set_keymap("n", "<leader>ic", ":lua require('package-info').hide()<CR>", { silent = true, noremap = true })
    -- Update package on line
    vim.api.nvim_set_keymap("n", "<leader>iu", ":lua require('package-info').update()<CR>", { silent = true, noremap = true })
    -- Delete package on line
    vim.api.nvim_set_keymap("n", "<leader>id", ":lua require('package-info').delete()<CR>", { silent = true, noremap = true })
    -- Install a new package
    vim.api.nvim_set_keymap("n", "<leader>ii", ":lua require('package-info').install()<CR>", { silent = true, noremap = true })
    -- Reinstall dependencies
    vim.api.nvim_set_keymap("n", "<leader>ir", ":lua require('package-info').reinstall()<CR>", { silent = true, noremap = true })
    -- Install a different package version
    vim.api.nvim_set_keymap("n", "<leader>ip", ":lua require('package-info').change_version()<CR>", { silent = true, noremap = true })

    if akyrey.builtin.package_info.on_config_done then
        akyrey.builtin.package_info.on_config_done(package_info)
    end
end

return M


