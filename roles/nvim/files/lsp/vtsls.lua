-- TypeScript/JavaScript. Replaces the dead `tsserver = {}` entry in the old
-- config: that name was renamed to ts_ls years ago and never started.
return {
  cmd = { "vtsls", "--stdio" },
  -- Neovim reports .jsx/.tsx as javascriptreact/typescriptreact; the dotted
  -- "javascript.jsx" forms lspconfig used to list are never produced.
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
  settings = {
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
