return {
  -- Installs language servers, formatters, linters and debug adapters.
  -- Used purely as a package manager: server configuration lives in lsp/*.lua
  -- and is enabled by core/lsp.lua, with no mason-lspconfig bridge.
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    lazy = false,
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ensure_installed = {
        -- language servers
        "ansible-language-server",
        "bash-language-server",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "emmet-ls",
        "gopls",
        "gomodifytags", -- used by gopher.nvim
        "impl", -- used by gopher.nvim
        "html-lsp",
        "intelephense",
        "json-lsp",
        "lua-language-server",
        "tailwindcss-language-server",
        "vtsls",
        "yaml-language-server",
        -- formatters
        "blade-formatter",
        "gofumpt",
        "goimports-reviser",
        "prettier",
        "shfmt",
        "stylua",
        -- linters
        "eslint_d",
        "shellcheck",
        -- debug adapters
        "delve",
        "js-debug-adapter",
        "php-debug-adapter",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- mason.nvim v2 dropped automatic installation of `ensure_installed`,
      -- so trigger it once the registry is ready.
      local registry = require("mason-registry")
      registry.refresh(function()
        for _, name in ipairs(opts.ensure_installed) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end)
    end,
  },

  -- Lua LSP that understands the Neovim API and this config's own modules.
  -- Replaces neoconf/neodev, hence no .neoconf.json in this config.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },

  -- Go struct tags and interface stubs.
  --
  -- These were previously code-action sources on none-ls (gomodifytags and
  -- impl, pulled in by LazyVim's lang.go extra). Dropping none-ls took them
  -- with it, so they come back here as explicit commands instead.
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    -- The gomodifytags and impl binaries it shells out to are installed by
    -- mason above, so no :GoInstallDeps build step here.
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>cgt", "<cmd>GoTagAdd json<cr>", ft = "go", desc = "Add json struct tags" },
      { "<leader>cgy", "<cmd>GoTagAdd yaml<cr>", ft = "go", desc = "Add yaml struct tags" },
      { "<leader>cgd", "<cmd>GoTagAdd db<cr>", ft = "go", desc = "Add db struct tags" },
      { "<leader>cgT", "<cmd>GoTagRm json<cr>", ft = "go", desc = "Remove json struct tags" },
      { "<leader>cgi", "<cmd>GoImpl<cr>", ft = "go", desc = "Implement interface" },
    },
  },

  -- JSON and YAML schema catalog, consumed by lsp/jsonls.lua and lsp/yamlls.lua.
  { "b0o/SchemaStore.nvim", lazy = true, version = false },
}
