-- Workspace library setup is handled by lazydev.nvim, so there is no manual
-- runtimepath scanning here.
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim", "Snacks" } },
      hint = { enable = true },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      format = { enable = false }, -- stylua does the formatting
    },
  },
}
