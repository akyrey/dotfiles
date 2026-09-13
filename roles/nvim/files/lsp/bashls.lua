return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "bash", "sh", "zsh" },
  root_markers = { ".git" },
  settings = {
    bashIde = {
      -- shellcheck is installed by mason; this is the integration switch.
      shellcheckPath = "shellcheck",
    },
  },
}
