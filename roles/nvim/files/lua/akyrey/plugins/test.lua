return {
    -- Adapters
    { "nvim-neotest/neotest-go" },
    { "nvim-neotest/neotest-plenary" },
    { "olimorris/neotest-phpunit" },
    {
        "nvim-neotest/neotest",
        config = function()
            local neotest_ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- Replace newline and tab characters with space for more compact diagnostics
                        local message =
                            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                        return message
                    end,
                },
            }, neotest_ns)
            require("neotest").setup({
                adapters = {
                    require("neotest-go"),
                    require("neotest-phpunit")({
                        phpunit_cmd = function()
                            -- local utils = require("akyrey.utils")
                            -- local root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1])
                            -- if root_dir ~= nil and utils.file_exists(utils.join_paths(root_dir, "xenv")) then
                            --     return utils.join_paths(root_dir, "xenv") .. " run ./phpunit_xdebug"
                            -- end

                            return "vendor/bin/phpunit"
                        end,
                        dap = require("dap").configurations.php[1],
                    }),
                    require("neotest-plenary"),
                },
            })
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
