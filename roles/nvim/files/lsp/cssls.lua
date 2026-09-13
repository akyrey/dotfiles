local lsp = require("util.lsp")

return {
  cmd = lsp.node_cmd("vscode-css-language-server"),
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  settings = {
    -- Tailwind's @apply/@tailwind at-rules are not standard CSS.
    css = { validate = true, lint = { unknownAtRules = "ignore" } },
    scss = { validate = true, lint = { unknownAtRules = "ignore" } },
    less = { validate = true, lint = { unknownAtRules = "ignore" } },
  },
}
