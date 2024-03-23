return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
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
          require("mason-registry").get_package("php-debug-adapter"):get_install_path() .. "/extension/out/phpDebug.js",
        },
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
          name = "Docker: Listen for Xdebug 2",
          type = "php",
          request = "launch",
          port = 9000,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
          xdebugSettings = {
            max_children = 50,
            max_depth = 5,
            max_data = 4096,
          },
        },
        {
          name = "Docker: Listen for Xdebug 3",
          type = "php",
          request = "launch",
          port = 9003,
          pathMappings = {
            ["/skp-svc/src"] = "${workspaceFolder}",
          },
          xdebugSettings = {
            max_children = 50,
            max_depth = 5,
            max_data = 4096,
          },
        },
      }
    end,
  },
  {
    "nvim-neotest/nvim-nio",
  },
  {
    "rcarriga/nvim-dap-ui",
    requires = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },
}
