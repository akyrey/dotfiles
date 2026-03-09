return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")
    local uv = vim.loop
    local function exec_docker_or_global(exe)
      local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
      -- Try to use the local version of the executable first (e.g., from a Docker container)
      local local_path = table.concat({ "dev", "bin", exe }, path_sep)
      if uv.fs_stat(local_path) then
        return local_path
      end
      -- If the local version is not found, check if "xenv" is available and use it to execute the global version
      if vim.fn.executable("xenv") == 1 then
        return "x " .. exe
      end
      -- If "xenv" is not available, check if "sail" is available and use it to execute the global version
      if vim.fn.executable("sail") == 1 then
        return "sail " .. exe
      end

      -- Simply run default executable, which will rely on PATH and possibly be a global installation
      local vendor_path = table.concat({ "vendor", "bin", exe }, path_sep)
      return vim.fn.executable(vendor_path) == 1 and vendor_path or exe
    end

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
        command = exec_docker_or_global("phpcs"),
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
        command = exec_docker_or_global("phpstan"),
      }),
    })

    local remove_sources = { "goimports", "gofumpt", "phpcsfixer", "pint" }
    opts.sources = vim.tbl_filter(function(source)
      return not vim.tbl_contains(remove_sources, source.name)
    end, opts.sources)
  end,
}
