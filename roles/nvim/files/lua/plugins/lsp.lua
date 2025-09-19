return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      diagnostics = {
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          format = function(d)
            local code = d.code or (d.user_data and d.user_data.lsp.code)
            if code then
              return string.format("%s [%s]", d.message, code):gsub("1. ", "")
            end
            return d.message
          end,
        },
      },
      inlay_hints = {
        enabled = true,
      },
      --- @type lspconfig.options
      servers = {
        ansiblels = {},
        bashls = {},
        dockerls = {},
        emmet_ls = {
          filetypes = {
            "astro",
            "blade",
            "css",
            "eruby",
            "html",
            "htmldjango",
            "javascriptreact",
            "less",
            "pug",
            "sass",
            "scss",
            "svelte",
            "typescriptreact",
            "vue",
          },
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
            },
          },
        },
        intelephense = {
          filetypes = { "blade", "php" },
          settings = {
            intelephense = {
              filetypes = { "php", "blade", "php_only" },
              files = {
                associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
                maxSize = 5000000,
                exclude = {
                  "**/.git/**",
                  "**/.svn/**",
                  "**/.hg/**",
                  "**/CVS/**",
                  "**/.DS_Store/**",
                  "**/node_modules/**",
                  "**/bower_components/**",
                  "**/vendor/**/{Tests,tests}/**",
                  "**/.phpstan/**",
                  "**/.history/**",
                  "**/.null-ls**",
                  "**/vendor/**/vendor/**",
                  "**/work/**/application/cache/**",
                  "**/work/**/tests/coverage/**",
                },
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              hint = { enable = true },
              telemetry = { enable = false },
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        rust_analyzer = {},
        tsserver = {},
      },
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      -- setup = {
      --   tsserver = function()
      --     return true
      --   end,
      -- },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ansible-language-server",
        "bash-language-server",
        "blade-formatter",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "emmet-ls",
        "eslint_d",
        "gopls",
        "html-lsp",
        "intelephense",
        "lua-language-server",
        "php-debug-adapter",
        "prettier",
        "rust-analyzer",
        "rustywind",
        "shellcheck",
        "stylua",
        "tailwindcss-language-server",
        "templ",
        "typescript-language-server",
        "yaml-language-server",
      })
    end,
  },
}
