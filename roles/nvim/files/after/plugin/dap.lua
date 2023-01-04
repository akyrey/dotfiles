local d_ok, dap = pcall(require, "dap")
local u_ok, ui = pcall(require, "dapui")

if not d_ok or not u_ok then
    return
end

local config = {
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

vim.fn.sign_define("DapBreakpoint", config.breakpoint)
vim.fn.sign_define("DapBreakpointRejected", config.breakpoint_rejected)
vim.fn.sign_define("DapStopped", config.stopped)

dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

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

vim.keymap.set("n", "<leader>dt", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>db", function() dap.step_back() end, { desc = "Step Back" })
vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Continue" })
vim.keymap.set("n", "<leader>dC", function() dap.run_to_cursor() end, { desc = "Run To Cursor" })
vim.keymap.set("n", "<leader>dd", function() dap.disconnect() end, { desc = "Disconnect" })
vim.keymap.set("n", "<leader>dg", function() dap.session() end, { desc = "Get Session" })
vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", function() dap.step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>du", function() dap.step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dp", function() dap.pause.toggle() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "Toggle Repl" })
vim.keymap.set("n", "<leader>ds", function() dap.continue() end, { desc = "Start" })
vim.keymap.set("n", "<leader>dq", function() dap.close() end, { desc = "Quit" })
vim.keymap.set("n", "<leader>dU", function() ui.toggle({ reset = true }) end, { desc = "Toggle UI" })
