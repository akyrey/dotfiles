-- Small helpers shared by the lsp/*.lua server definitions.
local M = {}

--- Build a `cmd` that prefers a project-local node_modules binary over the
--- globally installed one, matching what nvim-lspconfig used to do for the
--- vscode-* language servers.
---@param exe string executable name, e.g. "vscode-json-language-server"
---@param args string[]? extra arguments, defaults to { "--stdio" }
---@return fun(dispatchers: table, config: table): table
function M.node_cmd(exe, args)
  args = args or { "--stdio" }
  return function(dispatchers, config)
    local cmd = exe
    if config and config.root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules", ".bin", exe)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start(vim.list_extend({ cmd }, args), dispatchers)
  end
end

return M
