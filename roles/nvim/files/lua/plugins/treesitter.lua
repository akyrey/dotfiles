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
      require("nvim-treesitter.parsers").blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          revision = "b5291d1ba207a8ebb8383b2ecb8a8a6535210a50",
        },
        -- blade injects php_only and html, so those parsers must exist too
        requires = { "html", "php_only" },
        tier = 3,
      }

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

  -- Treesitter-aware textobjects and motions (af/if, ac/ic, ]f, [f, ...).
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local map = vim.keymap.set

      -- af/if, ac/ic, aa/ia select function, class and parameter.
      for key, obj in pairs({ f = "function", c = "class", a = "parameter" }) do
        map({ "x", "o" }, "a" .. key, function()
          select.select_textobject("@" .. obj .. ".outer", "textobjects")
        end, { desc = "Select outer " .. obj })
        map({ "x", "o" }, "i" .. key, function()
          select.select_textobject("@" .. obj .. ".inner", "textobjects")
        end, { desc = "Select inner " .. obj })
      end

      map({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      map({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Prev function start" })
      map({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })
      map({ "n", "x", "o" }, "[c", function()
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
