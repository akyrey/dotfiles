return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "ThePrimeagen/refactoring.nvim",
        config = function()
          require("telescope").load_extension("refactoring")
        end,
      },
    },
    opts = function(_, opts)
      opts.defaults = vim.tbl_extend("force", opts.defaults or {}, {
        file_ignore_patterns = {
          ".git/.*",
          "node_modules/.*",
          "documentation/.*",
          "tests/coverage/.*",
          "package-lock.json",
        },
        prompt_prefix = " ",
        selection_caret = " ",
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      })

      opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
      })
    end,
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("telescope").load_extension("git_worktree")
    end,
  },
}
