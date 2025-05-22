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

          return "./vendor/bin/phpcs"
        end,
      }),
      nls.builtins.diagnostics.phpstan.with({
        args = {
          "analyze",
          "-c",
          ".phpstan/phpstorm.neon",
          "--error-format",
          "json",
          "--no-progress",
          "$FILENAME",
        },
        command = function()
          local root_patterns = { ".git" }
          local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
          local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
          if root_dir ~= nil then
            local filename = table.concat({ root_dir, "dev", "bin", "phpstan" }, path_sep)
            local f = io.open(filename, "r")
            if f ~= nil then
              io.close(f)
              return filename
            end
          end

          return "./vendor/bin/phpstan"
        end,
      }),
      nls.builtins.formatting.phpcsfixer.with({
        args = {
          "--no-interaction",
          "--quiet",
          "--config=.php-cs-fixer.dist.php",
          "fix",
          "$FILENAME",
        },
        -- Use php-cs-fixer only when a .php-cs-fixer.dist.php file is present
        condition = function(ctx)
          return vim.fs.find({ ".php-cs-fixer.dist.php" }, { path = ctx.filename, upward = true })[1]
        end,
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
      }),
      nls.builtins.formatting.prettier.with({
        extra_filetypes = { "astro" },
      }),
    })
    local remove_sources = { "goimports", "gofumpt" }
    opts.sources = vim.tbl_filter(function(source)
      return not vim.tbl_contains(remove_sources, source.name)
    end, opts.sources)
  end,
}
