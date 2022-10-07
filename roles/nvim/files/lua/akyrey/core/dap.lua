local M = {}
local Log = require "akyrey.core.log"

M.config = function()
  akyrey.builtin.dap = {
    active = true,
    on_config_done = nil,
    breakpoint = {
      text = "",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    breakpoint_rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }
end

M.setup = function()
  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    Log:error "Failed to load dap"
    return
  end
  local dapui_status_ok, dapui = pcall(require, "dapui")
  if not dapui_status_ok then
    Log:error "Failed to load dapui"
    return
  end
  local dap_install_status_ok, dap_install = pcall(require, "dap-install")
  if not dap_install_status_ok then
    Log:error "Failed to load dap_install"
    return
  end
  local dbg_list = require("dap-install.api.debuggers").get_installed_debuggers()

  vim.fn.sign_define("DapBreakpoint", akyrey.builtin.dap.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", akyrey.builtin.dap.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", akyrey.builtin.dap.stopped)

  dap.defaults.fallback.terminal_win_cmd = "50vsplit new"


  for _, debugger in ipairs(dbg_list) do
	dap_install.config(debugger)
  end

  dap.configurations.typescript = {
    {
      name = "Debug (Attach) - Remote",
      type = "chrome",
      request = "attach",
      program = "${file}",
      debugServer = 45635,
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      webRoot = "${workspaceFolder}",
    }
  }

  dapui.setup()
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  if akyrey.builtin.dap.on_config_done then
    akyrey.builtin.dap.on_config_done(dap)
  end
end

-- TODO put this up there ^^^ call in ftplugin

-- M.dap = function()
--   if akyrey.plugin.dap.active then
--     local dap_install = require "dap-install"
--     dap_install.config("python_dbg", {})
--   end
-- end
--
-- M.dap = function()
--   -- gem install readapt ruby-debug-ide
--   if akyrey.plugin.dap.active then
--     local dap_install = require "dap-install"
--     dap_install.config("ruby_vsc_dbg", {})
--   end
-- end

return M
