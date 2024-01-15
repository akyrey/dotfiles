-- Debugging
return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("akyrey.config.dap").setup()
        end,
        dependencies = {
            { "williamboman/mason.nvim" },
        },
        opts = function()
            local dap = require("dap")
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                        .. "/js-debug/src/dapDebugServer.js",
                        "${port}",
                    },
                },
            }
            dap.adapters["php"] = {
                type = "executable",
                command = "node",
                args = {
                    require("mason-registry").get_package("php-debug-adapter"):get_install_path()
                    .. "/extension/out/phpDebug.js",
                }
            }
            for _, language in ipairs({ "typescript", "javascript" }) do
                if not dap.configurations[language] then
                    dap.configurations[language] = {
                        {
                            type = "pwa-node",
                            request = "launch",
                            name = "Launch file",
                            program = "${file}",
                            cwd = "${workspaceFolder}",
                        },
                        {
                            type = "pwa-node",
                            request = "attach",
                            name = "Attach",
                            processId = require("dap.utils").pick_process,
                            cwd = "${workspaceFolder}",
                        },
                    }
                end
            end
            dap.configurations.php = {
                {
                    name = "Listen for Xdebug",
                    type = "php",
                    request = "launch",
                    port = 9000,
                    xdebugSettings = {
                        max_children = 50,
                        max_depth = 5,
                        max_data = 4096
                    }
                },
                {
                    name = "Docker: Listen for Xdebug",
                    type = "php",
                    request = "launch",
                    port = 9000,
                    pathMappings = {
                        ["/var/www/html"] = "${workspaceFolder}"
                    },
                    xdebugSettings = {
                        max_children = 50,
                        max_depth = 5,
                        max_data = 4096
                    }
                }
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        config = function()
            require("akyrey.config.dap").setup_ui()
        end,
    },
}
