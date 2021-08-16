-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}

M.setup = function()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = akyrey.lsp.diagnostics.virtual_text,
    signs = akyrey.lsp.diagnostics.signs.active,
    underline = akyrey.lsp.document_highlight,
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, _, params, client_id, _)
    local config = { -- your config
      virtual_text = akyrey.lsp.diagnostics.virtual_text,
      signs = akyrey.lsp.diagnostics.signs,
      underline = akyrey.lsp.diagnostics.underline,
      update_in_insert = akyrey.lsp.diagnostics.update_in_insert,
      severity_sort = akyrey.lsp.diagnostics.severity_sort,
    }
    local uri = params.uri
    local bufnr = vim.uri_to_bufnr(uri)

    if not bufnr then
      return
    end

    local diagnostics = params.diagnostics

    for i, v in ipairs(diagnostics) do
      local source = v.source
      if source then
        if string.find(source, "/") then
          source = string.sub(v.source, string.find(v.source, "([%w-_]+)$"))
        end
        diagnostics[i].message = string.format("%s: %s", source, v.message)
      else
        diagnostics[i].message = string.format("%s", v.message)
      end

      if vim.tbl_contains(vim.tbl_keys(v), "code") then
        diagnostics[i].message = diagnostics[i].message .. string.format(" [%s]", v.code)
      end
    end

    vim.lsp.diagnostic.save(diagnostics, bufnr, client_id)

    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end

    vim.lsp.diagnostic.display(diagnostics, bufnr, client_id, config)
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = akyrey.lsp.popup_border,
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = akyrey.lsp.popup_border,
  })
end

return M
