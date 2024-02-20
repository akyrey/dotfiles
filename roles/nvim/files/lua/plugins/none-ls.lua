return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.sources = vim.list_extend(opts.sources or {}, {
      -- PHP
      nls.builtins.diagnostics.phpcs.with({
        args = {
          "--report=json",
          "-q",
          "-s",
          "--runtime-set",
          "ignore_warnings_on_exit",
          "1",
          "--runtime-set",
          "ignore_errors_on_exit",
          "1",
          "--standard=.phpcs.xml",
          "--stdin-path=$FILENAME",
          "--basepath=",
        },
        command = function()
          local root_patterns = { ".git" }
          local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
          local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
          if root_dir ~= nil then
            local filename = table.concat({ root_dir, "dev", "bin", "phpcs" }, path_sep)
            local f = io.open(filename, "r")
            if f ~= nil then
              io.close(f)
              return filename
            end
          end

          return "phpcs"
        end,
      }),
    })
  end,
}
