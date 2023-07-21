local M = {}

---Test if current LSP client supports the given method
---@param method string
function M.has(buffer, method)
    method = method:find("/") and method or "textDocument/" .. method
    local clients = vim.lsp.get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then
            return true
        end
    end
    return false
end

function M.add_lsp_buffer_keybindings(bufnr)
    local nmap = function(keys, func, desc, has)
        if not has or M.has(bufnr, has) then
            if desc then
                desc = "LSP: " .. desc
            end

            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame", "rename")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", "codeAction")
    nmap("<leader>cl", vim.lsp.codelens.run, "[C]ode[L]ens Actions", "codeLens")

    nmap("gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, "[G]oto [D]efinition",
        "definition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,
        "[G]oto [I]mplementation")
    nmap("gl", vim.diagnostic.open_float, "[L]ine Diagnostics")
    nmap("<leader>D", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end,
        "Type [D]efinition")
    nmap("<leader>sds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation", "signatureHelp")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        require("akyrey.lsp.utils").format()
    end, { desc = "Format current buffer with LSP" })
    nmap("<leader>lf", function() vim.cmd "Format" end, "[L]SP [F]ormat")
    nmap("<leader>go", function() M.organize_imports() end, "Or[g]anize Imp[o]rts")
end

function M.organize_imports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
    }
    vim.lsp.buf.execute_command(params)
end

function M.setup_document_highlight(client, bufnr)
    local status_ok, highlight_supported = pcall(function()
        return client.supports_method "textDocument/documentHighlight"
    end)
    if not status_ok or not highlight_supported then
        return
    end
    local group = "lsp_document_highlight"
    local hl_events = { "CursorHold", "CursorHoldI" }

    local ok, hl_autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = group,
        buffer = bufnr,
        event = hl_events,
    })

    if ok and #hl_autocmds > 0 then
        return
    end

    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_create_autocmd(hl_events, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
    })
end

function M.setup_codelens_refresh(client, bufnr)
    local status_ok, codelens_supported = pcall(function()
        return client.supports_method "textDocument/codeLens"
    end)
    if not status_ok or not codelens_supported then
        return
    end
    local group = "lsp_code_lens_refresh"
    local cl_events = { "BufEnter", "InsertLeave" }
    local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = group,
        buffer = bufnr,
        event = cl_events,
    })

    if ok and #cl_autocmds > 0 then
        return
    end
    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_create_autocmd(cl_events, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
    })
end

function M.common_capabilities()
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {}
    )
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    return capabilities
end

function M.enable_inlay_hints(client, buffer)
    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

    if inlay_hint then
        if client.server_capabilities.inlayHintProvider then
            inlay_hint(buffer, true)
        end
    end
end

---filter passed to vim.lsp.buf.format
---always selects null-ls if it's available and caches the value per buffer
---@param client table client attached to a buffer
---@return boolean if client matches
function M.format_filter(client)
    local filetype = vim.bo.filetype
    local n = require "null-ls"
    local s = require "null-ls.sources"
    local method = n.methods.FORMATTING
    local available_formatters = s.get_available(filetype, method)

    if #available_formatters > 0 then
        return client.name == "null-ls"
    elseif client.supports_method "textDocument/formatting" then
        return true
    else
        return false
    end
end

---Simple wrapper for vim.lsp.buf.format() to provide defaults
---@param opts table|nil
function M.format(opts)
    opts = opts or {}
    opts.filter = opts.filter or M.format_filter

    return vim.lsp.buf.format(opts)
end

return M
