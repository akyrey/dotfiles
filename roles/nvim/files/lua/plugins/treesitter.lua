return {
  "nvim-treesitter/nvim-treesitter",
  opts = function()
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "blade",
    }
    parser_config.templ = {
      install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
    }
    vim.treesitter.language.register("templ", "templ")

    return {
      ensure_installed = {
        "astro",
        "bash",
        "css",
        "git_config",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "markdown",
        "php",
        "phpdoc",
        "rust",
        "scss",
        "sql",
        "templ",
        "toml",
        "typescript",
        "yaml",
      },
    }
  end,
}
