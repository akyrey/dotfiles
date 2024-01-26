local M = {}

M.setup = function()
    local d_ok, dap = pcall(require, "dap")

    if not d_ok then
        return
    end

    local icons = require("akyrey.config.icons").dap
    local config = {
        breakpoint = {
            text = icons.Breakpoint,
            texthl = "LspDiagnosticsSignError",
            linehl = "",
            numhl = "",
        },
        breakpoint_rejected = {
            text = icons.BreakpointRejected,
            texthl = "LspDiagnosticsSignHint",
            linehl = "",
            numhl = "",
        },
        stopped = {
            text = icons.Stopped,
            texthl = "LspDiagnosticsSignInformation",
            linehl = "DiagnosticUnderlineInfo",
            numhl = "LspDiagnosticsSignInformation",
        },
    }

    vim.fn.sign_define("DapBreakpoint", config.breakpoint)
    vim.fn.sign_define("DapBreakpointRejected", config.breakpoint_rejected)
    vim.fn.sign_define("DapStopped", config.stopped)

    dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
end

M.setup_ui = function()
    local d_ok, dap = pcall(require, "dap")
    local u_ok, ui = pcall(require, "dapui")

    if not d_ok or not u_ok then
        return
    end

    ui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
        ui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        ui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        ui.close()
    end
end

return M
