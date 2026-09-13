-- Replaces none-ls.nvim, which existed in the old config only to run phpcs and
-- phpstan. nvim-lint has both built in, so this drops a plugin and the code
-- that filtered LazyVim's own none-ls sources back out.
--
-- The PHP linters need the same docker/xenv/sail resolution as the formatters,
-- and they must run from the project root so .phpcs.xml and the phpstan config
-- resolve. nvim-lint's `wrap_linter` hook exists for exactly this: it runs just
-- before cmd and args are evaluated, so the command can be resolved per buffer.
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  opts = {
    linters_by_ft = {
      php = { "phpcs", "phpstan" },
      blade = { "phpcs" },
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    },
  },
  config = function(_, opts)
    local lint = require("lint")
    local exec = require("util.exec")

    lint.linters_by_ft = opts.linters_by_ft

    -- Extra arguments layered on top of nvim-lint's built-in definitions.
    -- phpcs reads the buffer over stdin (hence the trailing "-"); phpstan does
    -- not, so nvim-lint appends the filename itself and we must not.
    local EXTRA_ARGS = {
      phpcs = function()
        return {
          "--report=json",
          "-q",
          "-s",
          -- Report findings without a non-zero exit, so nvim-lint sees output.
          "--runtime-set",
          "ignore_warnings_on_exit",
          "1",
          "--runtime-set",
          "ignore_errors_on_exit",
          "1",
          "--standard=.phpcs.xml",
          "--stdin-path=" .. vim.api.nvim_buf_get_name(0),
          "--basepath=",
          "-",
        }
      end,
      phpstan = function(root)
        local args = { "analyze", "--error-format", "json", "--no-progress" }
        -- skp-core keeps its config out of the default location; other projects
        -- use a plain phpstan.neon that phpstan finds on its own.
        local custom = vim.fs.joinpath(root, ".phpstan", "phpstorm.neon")
        if vim.uv.fs_stat(custom) then
          table.insert(args, 2, ".phpstan/phpstorm.neon")
          table.insert(args, 2, "-c")
        end
        return args
      end,
    }

    ---@param linter lint.Linter
    ---@return lint.Linter
    local function wrap_linter(linter)
      local build = EXTRA_ARGS[linter.name]
      if not build then
        return linter
      end
      local root = exec.project_root(0)
      local resolved = exec.php_tool(linter.name, 0)
      return vim.tbl_extend("force", linter, {
        cmd = resolved.cmd,
        -- Wrappers (xenv, sail) take the tool name as their first argument.
        args = vim.list_extend(vim.deepcopy(resolved.args), build(root)),
        cwd = root,
      })
    end

    -- A PHP linter with no config in the project just errors out. Skip it
    -- rather than showing a failure notification on every save: not every
    -- repo here carries a .phpcs.xml or a phpstan config.
    local CONFIGS = {
      phpcs = { ".phpcs.xml", ".phpcs.xml.dist", "phpcs.xml", "phpcs.xml.dist" },
      phpstan = { ".phpstan/phpstorm.neon", "phpstan.neon", "phpstan.neon.dist" },
    }

    ---@param linter lint.Linter
    ---@return boolean
    local function filter(linter)
      local candidates = CONFIGS[linter.name]
      if not candidates then
        return true
      end
      local root = exec.project_root(0)
      for _, rel in ipairs(candidates) do
        if vim.uv.fs_stat(vim.fs.joinpath(root, rel)) then
          return true
        end
      end
      return false
    end

    local function run()
      -- Linters that read from disk produce nonsense on scratch and unnamed
      -- buffers, so only lint real files.
      if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" then
        return
      end
      lint.try_lint(nil, { wrap_linter = wrap_linter, filter = filter })
    end

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("akyrey_lint", { clear = true }),
      callback = run,
    })

    vim.keymap.set("n", "<leader>cl", run, { desc = "Lint buffer" })
  end,
}
