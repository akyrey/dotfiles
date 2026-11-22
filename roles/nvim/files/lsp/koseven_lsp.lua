-- Kohana/Koseven framework server (akyrey/koseven-lsp).
-- Installed by the Ansible role with `go install`, so it lives in $GOPATH/bin.
return {
  cmd = { "koseven-lsp" },
  filetypes = { "php" },
  -- `root_markers` can't express this: it resolves a marker to the directory
  -- the marker sits in, so "application/bootstrap.php" would root the server at
  -- <project>/application rather than <project>. A predicate walks the ancestors
  -- and returns the project directory itself.
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, function(name, path)
      if name == "koseven-ls.toml" then
        return true
      end
      if name == "application" then
        return vim.uv.fs_stat(vim.fs.joinpath(path, "application", "bootstrap.php")) ~= nil
      end
      return false
    end)
    if root then
      on_dir(root)
    end
  end,
  -- Never start for a loose PHP file outside a Koseven project.
  workspace_required = true,
}
