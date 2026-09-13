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

    return {
      -- Autoformat is off by default (vim.g.autoformat = false); core/format.lua
      -- decides per buffer, and <leader>uf / <leader>uF toggle it.
      format_on_save = function(bufnr)
        if not require("core.format").enabled(bufnr) then
          return nil
        end
        return { timeout_ms = 20000, lsp_format = "fallback" }
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
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
        -- Laravel projects use pint; everything else uses php-cs-fixer.
        php = function(bufnr)
          return exec.has_pint(bufnr) and { "pint" } or { "phpcsfixer" }
        end,
      },
      formatters = {
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
              return exec.project_root(bufnr)
            end,
          }
        end,
        phpcsfixer = function(bufnr)
          local resolved = exec.php_tool("php-cs-fixer", bufnr)
          return {
            meta = {
              url = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer",
              description = "The PHP Coding Standards Fixer.",
            },
            command = resolved.cmd,
            args = vim.list_extend(vim.deepcopy(resolved.args), {
              "--config=.php-cs-fixer.dist.php",
              "fix",
              "$RELATIVE_FILEPATH",
            }),
            stdin = false,
            cwd = function()
              return exec.project_root(bufnr)
            end,
          }
        end,
      },
    }
  end,
}
