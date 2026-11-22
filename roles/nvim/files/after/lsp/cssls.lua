-- Overrides on top of nvim-lspconfig's lsp/cssls.lua.
return {
  settings = {
    -- Tailwind's @apply/@tailwind at-rules are not standard CSS.
    css = { validate = true, lint = { unknownAtRules = "ignore" } },
    scss = { validate = true, lint = { unknownAtRules = "ignore" } },
    less = { validate = true, lint = { unknownAtRules = "ignore" } },
  },
}
