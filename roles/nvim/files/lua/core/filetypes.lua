-- Custom filetype detection. Replaces the old ftdetect/*.lua vimscript autocmds.
--
-- The compound `yaml.*` filetypes matter: they are what routes a buffer to
-- docker_compose_language_service or ansiblels instead of plain yamlls.
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
  filename = {
    ["tsconfig.json"] = "jsonc",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    -- Dockerfile, Dockerfile.dev, Dockerfile.prod, ...
    ["Dockerfile.*"] = "dockerfile",
    -- any path ending in /gitconfig, e.g. roles/git/files/gitconfig
    [".*/gitconfig"] = "gitconfig",
    -- tsconfig.app.json, tsconfig.node.json, ...
    ["tsconfig%..*%.json"] = "jsonc",
    -- docker-compose.override.yml, docker-compose.prod.yml, ...
    ["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
    -- Ansible task files and playbooks in this dotfiles layout.
    [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
    -- GitLab CI
    ["%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
    -- Blade templates. The blade treesitter parser and queries/blade/*.scm
    -- handle highlighting; intelephense also claims this filetype.
    [".*%.blade%.php"] = "blade",
  },
})
