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

---Add function to be executed on LspAttach event
---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

function M.add_lsp_buffer_keybindings(client, buffer)
    local nmap = function(keys, func, desc, has, mode)
        if not has or M.has(buffer, has) then
            if desc then
                desc = "LSP: " .. desc
            end

            vim.keymap.set(mode or "n", keys, func, { buffer = buffer, desc = desc })
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
    nmap("<A-k>", vim.lsp.buf.signature_help, "Signature Documentation", "signatureHelp")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Format code
    nmap("<leader>lf", function() require("akyrey.lsp.format").format() end, "[F]ormat", "formatting")
    nmap("<leader>lf", function() require("akyrey.lsp.format").format() end, "[F]ormat Range", "rangeFormatting", "v")

    -- Client specific keymaps
    local servers = require("akyrey.lsp.config").server
    local maps = servers[client.name] and servers[client.name].keys or {}
    for _, keymap in ipairs(maps) do
        nmap(keymap.keys, keymap.func, keymap.desc, keymap.has, keymap.mode)
    end
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

return M
