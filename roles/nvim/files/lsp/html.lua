local lsp = require("util.lsp")

return {
  cmd = lsp.node_cmd("vscode-html-language-server"),
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
  init_options = {
    provideFormatter = false, -- prettier handles formatting
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { "html", "css", "javascript" },
  },
}
