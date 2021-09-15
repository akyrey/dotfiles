local M = {}

M.config = function ()
  vim.g.coq_settings = {
    auto_start = 'shut-up',
    clients = {
      tabnine = {
        enabled = true,
      }
    }
  }
end

return M
