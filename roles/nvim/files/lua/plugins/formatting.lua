return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.default_format_opts.timeout_ms = 20000
    opts.formatters_by_ft.go = { "gofumpt", "goimports_reviser" }
    opts.formatters_by_ft.php = { "php_cs_fixer" }
    opts.formatters_by_ft.blade = { "blade-formatter", "rustywind" }
    opts.formatters.php_cs_fixer = {
      args = {
        "--no-interaction",
        "--quiet",
        "--config=.php-cs-fixer.dist.php",
        "fix",
        "$FILENAME",
      },
      command = function()
        local root_patterns = { ".git" }
        local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
        local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
        if root_dir ~= nil then
          local filename = table.concat({ root_dir, "dev", "bin", "php-cs-fixer" }, path_sep)
          local f = io.open(filename, "r")
          if f ~= nil then
            io.close(f)
            return filename
          end
        end

        return "php-cs-fixer"
      end,
    }
  end,
}
