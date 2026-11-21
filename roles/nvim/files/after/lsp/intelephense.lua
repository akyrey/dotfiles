-- Overrides on top of nvim-lspconfig's lsp/intelephense.lua.
--
-- Main PHP language server. Also drives .blade.php files, which is why `blade`
-- is in filetypes and *.blade.php is in the file associations.
return {
  filetypes = { "php", "blade" },
  -- composer.json first, so a PHP project nested in a larger repo roots at itself.
  root_markers = { "composer.json", ".git" },
  settings = {
    intelephense = {
      telemetry = { enabled = false },
      filetypes = { "php", "blade", "php_only" },
      files = {
        associations = { "*.php", "*.blade.php" },
        maxSize = 5000000,
        exclude = {
          "**/.git/**",
          "**/.svn/**",
          "**/.hg/**",
          "**/CVS/**",
          "**/.DS_Store/**",
          "**/node_modules/**",
          "**/bower_components/**",
          "**/vendor/**/{Tests,tests}/**",
          "**/.phpstan/**",
          "**/.history/**",
          "**/vendor/**/vendor/**",
          "**/work/**/application/cache/**",
          "**/work/**/tests/coverage/**",
        },
      },
    },
  },
}
