local opts = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "akyrey" },
      },
      workspace = {
        library = {
          [require("akyrey.utils").join_paths(get_runtime_dir(), "akyrey", "lua")] = true,
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
return opts
