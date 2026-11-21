return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("core.format").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "v" },
      desc = "Format injected languages",
    },
  },
  opts = function()
    local exec = require("util.exec")
    local root = require("core.root")

    --- php-cs-fixer config file for the project, if it has one. Passing
    --- --config unconditionally fails in projects that use the non-dist name
    --- or rely on php-cs-fixer's built-in defaults.
    ---@param project string
    ---@return string?
    local function phpcsfixer_config(project)
      for _, name in ipairs({ ".php-cs-fixer.php", ".php-cs-fixer.dist.php" }) do
        if vim.uv.fs_stat(vim.fs.joinpath(project, name)) then
          return name
        end
      end
    end

    return {
      -- Autoformat is off by default (vim.g.autoformat = false); core/format.lua
      -- decides per buffer, and <leader>uf / <leader>uF toggle it.
      --
      -- After save rather than on save: pint and php-cs-fixer often run
      -- through docker, and a synchronous format-on-save froze the editor for
      -- as long as that took. conform formats asynchronously and writes again.
      format_after_save = function(bufnr)
        if not require("core.format").enabled(bufnr) then
          return nil
        end
        return { lsp_format = "fallback" }
      end,
      default_format_opts = {
        timeout_ms = 20000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        blade = { "blade-formatter" },
        css = { "prettier" },
        -- Note the hyphen: conform ships goimports-reviser.lua. The old config
        -- spelled it goimports_reviser, which silently resolved to nothing.
        go = { "gofumpt", "goimports-reviser" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        scss = { "prettier" },
        sh = { "shfmt" },
        sql = { "sql_formatter" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
        -- Laravel projects use pint; everything else uses php-cs-fixer.
        php = function(bufnr)
          return exec.has_pint(bufnr) and { "pint" } or { "phpcsfixer" }
        end,
      },
      formatters = {
        -- Every project database is MySQL; the default dialect rejects its syntax
        -- (backtick identifiers, ON DUPLICATE KEY UPDATE, ...).
        sql_formatter = {
          prepend_args = { "--language", "mysql" },
        },
        pint = function(bufnr)
          local resolved = exec.php_tool("pint", bufnr)
          return {
            meta = {
              url = "https://github.com/laravel/pint",
              description = "Laravel Pint is an opinionated PHP code style fixer for minimalists.",
            },
            command = resolved.cmd,
            args = vim.list_extend(vim.deepcopy(resolved.args), { "$RELATIVE_FILEPATH" }),
            stdin = false,
            cwd = function()
              return root.project(bufnr)
            end,
          }
        end,
        phpcsfixer = function(bufnr)
          local resolved = exec.php_tool("php-cs-fixer", bufnr)
          local config = phpcsfixer_config(root.project(bufnr))
          local args = vim.deepcopy(resolved.args)
          if config then
            table.insert(args, "--config=" .. config)
          end
          return {
            meta = {
              url = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer",
              description = "The PHP Coding Standards Fixer.",
            },
            command = resolved.cmd,
            args = vim.list_extend(args, { "fix", "$RELATIVE_FILEPATH" }),
            stdin = false,
            cwd = function()
              return root.project(bufnr)
            end,
          }
        end,
      },
    }
  end,
}
