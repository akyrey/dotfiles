return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })
  end,
  config = function(_, opts)
    ---@class ParserInfo[]
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
        generate_requires_npm = true,
        requires_generate_from_grammar = true,
      },
      filetype = "blade",
    }
    vim.filetype.add({
      pattern = {
        [".*%.blade%.php"] = "blade",
      },
    })

    parser_config.templ = {
      install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
    }
    vim.treesitter.language.register("templ", "templ")

    require("nvim-treesitter.configs").setup(opts)
  end,
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "css",
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "php",
      "phpdoc",
    })
  end,
}
