-- Overrides on top of nvim-lspconfig's lsp/bashls.lua.
return {
  -- Also attach to zsh scripts (this dotfiles repo has plenty).
  filetypes = { "bash", "sh", "zsh" },
}
