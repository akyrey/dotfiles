local opts = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "akyrey", "packer_plugins" },
      },
      workspace = {
        library = {
          [require("akyrey.utils").join_paths(get_runtime_dir(), "akyrey", "lua")] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
return opts
