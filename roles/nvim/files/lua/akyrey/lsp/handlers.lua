-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}

local diagnostics = {
    signs = {
        active = true,
        values = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn",  text = "" },
            { name = "DiagnosticSignHint",  text = "" },
            { name = "DiagnosticSignInfo",  text = "" },
        },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        format = function(d)
            local code = d.code or (d.user_data and d.user_data.lsp.code)
            if code then
                return string.format("%s [%s]", d.message, code):gsub("1. ", "")
            end
            return d.message
        end,
    },
}

local float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
}

function M.setup()
    local config = { -- your config
        virtual_text = diagnostics.virtual_text,
        signs = diagnostics.signs,
        underline = diagnostics.underline,
        update_in_insert = diagnostics.update_in_insert,
        severity_sort = diagnostics.severity_sort,
        float = diagnostics.float,
    }
    vim.diagnostic.config(config)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float)
end

function M.show_line_diagnostics()
    local config = diagnostics.float
    config.scope = "line"
    return vim.diagnostic.open_float(0, config)
end

return M
