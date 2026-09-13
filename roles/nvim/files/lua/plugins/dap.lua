return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/continue" },
      { "<leader>da", function() require("dap").continue({ before = function() return vim.fn.input("Args: ") end }) end, desc = "Run with args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      { "<leader>d?", function() require("dapui").eval(nil, { enter = true }) end, desc = "Display current word value" },
    },
    config = function()
      local dap = require("dap")

      -- Adapters. Both binaries come from mason (see plugins/lsp.lua).
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.expand("$MASON/share/js-debug-adapter/js-debug/src/dapDebugServer.js"),
            "${port}",
          },
        },
      }
      dap.adapters["php"] = {
        type = "executable",
        command = "node",
        args = { vim.fn.expand("$MASON/share/php-debug-adapter/extension/out/phpDebug.js") },
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

      -- Xdebug listeners. The path mapping is what differs between the
      -- containers: skp-core/sail mount at /var/www/html, the service repos
      -- at /skp-svc.
      local xdebug_settings = { max_children = 50, max_depth = 5, max_data = 4096 }
      dap.configurations.php = {
        {
          name = "Docker: Listen for Xdebug 3 - skp-core and sail",
          type = "php",
          request = "launch",
          port = 9003,
          pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
          xdebugSettings = xdebug_settings,
        },
        {
          name = "Docker: Listen for Xdebug 3 - wallet and totalizer",
          type = "php",
          request = "launch",
          port = 9003,
          pathMappings = { ["/skp-svc"] = "${workspaceFolder}" },
          xdebugSettings = xdebug_settings,
        },
        {
          name = "Docker: Listen for Xdebug 2",
          type = "php",
          request = "launch",
          port = 9000,
          pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
          xdebugSettings = xdebug_settings,
        },
      }
      -- blade buffers are still PHP as far as the debugger is concerned
      dap.configurations.blade = dap.configurations.php

      -- Breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "\u{25cf}", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "\u{25cf}", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "\u{25b6}", texthl = "DiagnosticInfo" })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)
      -- Open the UI when a session starts, close it when it ends.
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  { "nvim-neotest/nvim-nio", lazy = true },

  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    opts = {},
  },

  -- Go debugging via delve, with test-aware launch configs.
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
}
