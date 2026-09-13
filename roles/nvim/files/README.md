# Neovim configuration

A self-contained Neovim config with no distribution framework on top. Everything
the editor does is defined in this directory.

Requires Neovim 0.11+ (developed against 0.13-dev) for native `vim.lsp.config`
and `vim.lsp.enable`.

## Layout

```
init.lua                 entry point; requires each core module in order
lua/core/
  options.lua            vim.o / vim.g settings
  keymaps.lua            global keymaps (plugin keymaps live in their specs)
  autocmds.lua           global autocmds
  filetypes.lua          vim.filetype.add
  lazy.lua               lazy.nvim bootstrap + setup
  root.lua               project root detection (vim.g.root_spec)
  format.lua             the autoformat toggle conform asks about
  lsp.lua                diagnostics, LspAttach keymaps, vim.lsp.enable list
lua/util/
  exec.lua               resolving PHP tools through docker / xenv / sail / vendor
  lsp.lua                node_modules-aware cmd builder for the vscode-* servers
  treesitter.lua         "is there a parser/query for this?" helpers
lsp/<server>.lua         one file per language server, found on the runtimepath
lua/plugins/*.lua        plugin specs, one file per concern
after/ftplugin/*.lua     per-filetype settings
queries/blade/*.scm      highlight and injection queries for the blade parser
```

## How the pieces fit

**Plugins.** `lazy.nvim`, with `lua/plugins/` imported wholesale. Everything is
lazy-loaded by default; specs that must run at startup say `lazy = false`.

**LSP.** No `nvim-lspconfig`. Each server is a plain table in `lsp/<name>.lua`
that Neovim resolves off the runtimepath, and `lua/core/lsp.lua` names the ones
to turn on in a single `vim.lsp.enable({...})` call. `mason.nvim` is present
only to install binaries.

**Formatting.** `conform.nvim`. Format-on-save is off globally
(`vim.g.autoformat = false`); `<leader>uf` toggles it for a buffer and
`<leader>uF` globally, and `<leader>cf` formats on demand regardless.

**Linting.** `nvim-lint`. PHP linters are resolved per project and skipped
entirely when the project has no `.phpcs.xml` / phpstan config.

**PHP tooling.** `lua/util/exec.lua` decides how to run pint, php-cs-fixer,
phpcs and phpstan, preferring in order: `<root>/dev/bin/<tool>`, `<root>/xenv`,
`<root>/vendor/bin/sail`, `<root>/vendor/bin/<tool>`, then `$PATH`. `pint` is
chosen over `php-cs-fixer` when composer.json requires `laravel/pint`.

**Treesitter.** `nvim-treesitter` on the `main` branch: parsers are installed
from the list in `lua/plugins/treesitter.lua` and a `FileType` autocmd enables
highlighting and indenting per buffer. The blade grammar is registered there too
and uses the queries in `queries/blade/`.

## Adding a language server

1. Write `lsp/<name>.lua` returning `{ cmd, filetypes, root_markers, settings }`.
2. Add `"<name>"` to the `vim.lsp.enable({...})` list in `lua/core/lsp.lua`.
3. Add the binary to `ensure_installed` in `lua/plugins/lsp.lua`, or install it
   from the Ansible role if mason does not carry it.

## Adding a plugin

Add a spec to the matching file in `lua/plugins/`, or create a new one. Give it
a real load trigger (`event`, `ft`, `cmd` or `keys`) rather than leaving it
eager.
