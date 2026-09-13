-- core/filetypes.lua tags files under roles/*/tasks/ and playbooks as
-- `yaml.ansible` so this attaches instead of plain yamlls.
return {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
  root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
}
