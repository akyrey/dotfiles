return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })
  end,
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "css",
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "php",
      "phpdoc",
    })
  end,
}
