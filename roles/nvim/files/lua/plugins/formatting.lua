return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local util = require("conform.util")
    local uv = vim.loop
    local function exec_docker_or_global(exe)
      local root_patterns = { "composer.json", ".git" }
      local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
      local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"

      -- Try to use the local version of the executable first (e.g., from a Docker container)
      local local_path = table.concat({ root_dir, "dev", "bin", exe }, path_sep)
      if uv.fs_stat(local_path) then
        return local_path
      end

      local xenv_path = table.concat({ root_dir, "xenv" }, path_sep)
      -- If the local version is not found, check if "xenv" is available and use it to execute the global version
      if vim.fn.executable(xenv_path) == 1 then
        return xenv_path
      end

      local sail_path = table.concat({ root_dir, "vendor", "bin", "sail" }, path_sep)
      -- If "xenv" is not available, check if "sail" is available and use it to execute the global version
      if vim.fn.executable(sail_path) == 1 then
        return sail_path
      end

      -- Simply run default executable, which will rely on PATH and possibly be a global installation
      local vendor_path = table.concat({ root_dir, "vendor", "bin", exe }, path_sep)
      if vim.fn.executable(vendor_path) == 1 then
        return vendor_path
      end

      return exe
    end

    opts.default_format_opts.timeout_ms = 20000
    opts.formatters.pint = function()
      local cmd = exec_docker_or_global("pint")
      local args = { "$RELATIVE_FILEPATH" }
      if cmd:match("sail$") or cmd:match("xenv$") then
        table.insert(args, 1, "pint")
      end

      return {
        meta = {
          url = "https://github.com/laravel/pint",
          description = "Laravel Pint is an opinionated PHP code style fixer for minimalists.",
        },
        command = cmd,
        args = args,
        stdin = false,
      }
    end
    opts.formatters.phpcsfixer = {
      meta = {
        url = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer",
        description = "The PHP Coding Standards Fixer.",
      },
      command = exec_docker_or_global("php-cs-fixer"),
      args = {
        "--config=.php-cs-fixer.dist.php",
        "fix",
        "$RELATIVE_FILEPATH",
      },
      stdin = false,
      cwd = util.root_file({ "composer.json" }),
    }
    opts.formatters_by_ft.blade = { "blade-formatter" }
    opts.formatters_by_ft.go = { "gofumpt", "goimports_reviser" }
    opts.formatters_by_ft.php = function()
      local function has_pint()
        local composer = "composer.json"
        local fd = io.open(composer, "r")
        if not fd then
          return false
        end
        local content = fd:read("*a")
        fd:close()
        if not content then
          return false
        end
        local ok, json = pcall(vim.fn.json_decode, content)
        if not ok or not json then
          return false
        end
        local require = json.require or {}
        local require_dev = json["require-dev"] or {}
        return require["laravel/pint"] or require_dev["laravel/pint"]
      end

      return has_pint() and { "pint" } or { "phpcsfixer" }
    end
  end,
}
