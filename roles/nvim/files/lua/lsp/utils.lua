local M = {}

M.is_client_active = function(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == name then
      return true
    end
  end
  return false
end

M.get_active_client_by_ft = function(filetype)
  if not akyrey.lang[filetype] or not akyrey.lang[filetype].lsp then
    return nil
  end

  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == akyrey.lang[filetype].lsp.provider then
      return client
    end
  end
  return nil
end

return M
