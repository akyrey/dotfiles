-- Main PHP language server. Also drives .blade.php files, which is why `blade`
-- is in filetypes and *.blade.php is in the file associations.
return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php", "blade" },
  root_markers = { "composer.json", ".git" },
  settings = {
    intelephense = {
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
          "**/.null-ls**",
          "**/vendor/**/vendor/**",
          "**/work/**/application/cache/**",
          "**/work/**/tests/coverage/**",
        },
      },
    },
  },
}
