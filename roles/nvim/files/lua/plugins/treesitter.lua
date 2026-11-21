-- nvim-treesitter `main` branch. Unlike the old `master` branch there is no
-- global `configs.setup()` that enables highlighting everywhere: parsers are
-- installed up front, then a FileType autocmd opts each buffer in.
local PARSERS = {
  -- daily languages
  "php",
  "php_only",
  "blade",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "gotmpl",
  "dockerfile",
  "yaml",
  "json",
  "json5", -- jsonc has no grammar of its own; it uses the json parser
  "sql",
  -- config and scripting
  "lua",
  "luadoc",
  "luap",
  "bash",
  "vim",
  "vimdoc",
  "query",
  "regex",
  "toml",
  "xml",
  -- web
  "html",
  "css",
  "scss",
  "javascript",
  "jsdoc",
  "typescript",
  "tsx",
  -- docs and git
  "markdown",
  "markdown_inline",
  "diff",
  "gitcommit",
  "gitignore",
  "git_rebase",
  "printf",
  "c", -- required by several other grammars
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false, -- the tagged release predates the main-branch rewrite
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    config = function()
      local TS = require("nvim-treesitter")
      TS.setup({})

      -- Blade has no upstream grammar in nvim-treesitter, so register it here.
      -- The highlight and injection queries live in this config's queries/blade/.
      -- :TSUpdate reloads the parsers table, dropping anything added to it, so
      -- register again on its `User TSUpdate` event as nvim-treesitter's docs
      -- prescribe for custom parsers.
      local function register_blade()
        require("nvim-treesitter.parsers").blade = {
          install_info = {
            url = "https://github.com/EmranMR/tree-sitter-blade",
            revision = "b5291d1ba207a8ebb8383b2ecb8a8a6535210a50",
          },
          -- blade injects php_only and html, so those parsers must exist too
          requires = { "html", "php_only" },
          tier = 3,
        }
      end
      register_blade()
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("akyrey_treesitter_blade", { clear = true }),
        pattern = "TSUpdate",
        callback = register_blade,
      })

      -- Filetypes with no grammar of their own, pointed at a compatible one.
      -- Without this, tsconfig.json (jsonc) and .mdx files get no highlighting
      -- at all rather than falling back.
      vim.treesitter.language.register("json", "jsonc")
      vim.treesitter.language.register("markdown", "mdx")

      local util = require("util.treesitter")
      util.get_installed(true)

      local missing = vim.tbl_filter(function(lang)
        return not util.get_installed()[lang]
      end, PARSERS)
      if #missing > 0 then
        TS.install(missing, { summary = true }):await(function()
          util.get_installed(true)
        end)
      end

      -- Turn on highlighting, indenting and folding per buffer, but only where
      -- a parser and the matching query actually exist.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("akyrey_treesitter", { clear = true }),
        callback = function(ev)
          if not util.have(ev.match) then
            return
          end
          if util.have(ev.match, "highlights") then
            pcall(vim.treesitter.start, ev.buf)
          end
          if util.have(ev.match, "indents") then
            vim.bo[ev.buf].indentexpr = "v:lua.require'util.treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Treesitter-aware motions (]f, [f, ]C, [C). Selection textobjects
  -- (af/if, ac/ic, aa/ia, ...) come from mini.ai in plugins/coding.lua, which
  -- uses this plugin's queries.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      move = { set_jumps = true },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local move = require("nvim-treesitter-textobjects.move")
      local map = vim.keymap.set

      map({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      map({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Prev function start" })
      -- Upper-case C: ]c / [c stay the built-in next/prev change in diff mode.
      map({ "n", "x", "o" }, "]C", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })
      map({ "n", "x", "o" }, "[C", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Prev class start" })
    end,
  },

  -- Sticky header showing the enclosing function/class.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
    },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
        end,
        desc = "Toggle treesitter context",
      },
    },
  },
}
