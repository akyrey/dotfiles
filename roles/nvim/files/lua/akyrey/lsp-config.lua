-- Import nvim-lspconfig plugin
local nvim_lsp = require("lspconfig")

-- Configure diagnostic-languageserver to use ESLint
local filetypes = {
    typescript = "eslint",
    typescriptreact = "eslint",
}
local linters = {
    eslint = {
        sourceName = "eslint",
        command = "eslint_d",
        rootPatterns = {".eslintrc.js", "package.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}
local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}
local formatFiletypes = {
    typescript = "prettier",
    typescriptreact = "prettier"
}

-- Override default formatting with custom
local format_async = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then return end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end
vim.lsp.handlers["textDocument/formatting"] = format_async

-- Organize import like in VS Code
_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

-- Configure TypeScript language server
nvim_lsp.tsserver.setup {
    on_attach = function(client)
        -- Formatting will be handled by Prettier
        client.resolved_capabilities.document_formatting = false
    end
}

nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}

-- Configure PHP intelephense language server
nvim_lsp.intelephense.setup {}

-- Configure Angular language server
local angularls_cmd = {"ngserver", "--stdio", "--tsProbeLocations", "node_modules" , "--ngProbeLocations", "node_modules"}

nvim_lsp.angularls.setup {
  cmd = angularls_cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = angularls_cmd
  end,
}

-- Configure HTML language server
local html_capabilities = vim.lsp.protocol.make_client_capabilities()
html_capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.html.setup {
  capabilities = html_capabilities,
}
