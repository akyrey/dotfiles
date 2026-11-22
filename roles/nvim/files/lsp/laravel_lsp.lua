-- Laravel-aware completions for routes, views and config keys (akyrey/laravel-ls).
-- Installed by the Ansible role with `go install`.
return {
  cmd = { "laravel-lsp" },
  filetypes = { "php", "blade" },
  -- Resolved per-buffer by Neovim, unlike the old root_dir which was evaluated
  -- once at startup against whatever buffer happened to be current.
  root_markers = { "artisan" },
  workspace_required = true,
  init_options = {
    scanDirs = { "app", "modules" },
    referenceDirs = { "app", "routes", "modules", "modules/*/routes" },
  },
}
