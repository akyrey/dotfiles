-- Attaches only to compose files, which core/filetypes.lua tags as
-- `yaml.docker-compose`.
return {
  cmd = { "docker-compose-langserver", "--stdio" },
  filetypes = { "yaml.docker-compose" },
  root_markers = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" },
}
