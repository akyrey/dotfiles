local M = {}

-- Gets all lsp clients that support formatting.
-- When a null-ls formatter is available for the current filetype,
-- only null-ls formatters are returned.
function M.get_formatters(bufnr)
    local ft = vim.bo[bufnr].filetype
    -- check if we have any null-ls formatters for the current filetype
    local null_ls = package.loaded["null-ls"] and require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") or
        {}

    local ret = {
        ---@type lsp.Client[]
        active = {},
        ---@type lsp.Client[]
        available = {},
        null_ls = null_ls,
    }

    ---@type lsp.Client[]
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        if M.supports_format(client) then
            if (#null_ls > 0 and client.name == "null-ls") or #null_ls == 0 then
                table.insert(ret.active, client)
            else
                table.insert(ret.available, client)
            end
        end
    end

    return ret
end

-- Gets all lsp clients that support formatting
-- and have not disabled it in their client config
---@param client lsp.Client
function M.supports_format(client)
    if
        client.config
        and client.config.capabilities
        and client.config.capabilities.documentFormattingProvider == false
    then
        return false
    end
    return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

function M.format()
    local buf = vim.api.nvim_get_current_buf()

    local formatters = M.get_formatters(buf)
    local client_ids = vim.tbl_map(function(client)
        return client.id
    end, formatters.active)

    if #client_ids == 0 then
        return
    end

    vim.lsp.buf.format({
        bufnr = buf,
        filter = function(client)
            return vim.tbl_contains(client_ids, client.id)
        end,
    })
end

return M
