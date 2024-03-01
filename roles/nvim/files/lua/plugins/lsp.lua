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
      servers = {
        ansiblels = {},
        bashls = {},
        dockerls = {},
        intelephense = {},
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
      setup = {
        tsserver = function()
          return true
        end,
      },
    },
  },
  -- Replace tsserver with typescript-tools.nvim
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = function()
        vim.keymap.set("n", "<leader>co", "<cmd>TSToolsOrganizeImports<CR>", { desc = "LSP: Organize Imports" })
        vim.keymap.set(
          "n",
          "<leader>cR",
          "<cmd>TSToolsRemoveUnusedImports<CR>",
          { desc = "LSP: Remove Unused Imports" }
        )
      end,
      settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        -- "remove_unused_imports"|"organize_imports") -- or string "all"
        -- to include all supported code actions
        -- specify commands exposed as code_actions
        expose_as_code_action = "all",
        -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {},
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        -- described below
        tsserver_format_options = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
        tsserver_file_preferences = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
        -- locale of all tsserver messages, supported locales you can find here:
        -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
        tsserver_locale = "en",
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = true,
        include_completions_with_insert_text = true,
        -- CodeLens
        -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
        -- possible values: ("off"|"all"|"implementations_only"|"references_only")
        code_lens = "off",
        -- by default code lenses are displayed on all referencable values and for some of you it can
        -- be too much this option reduce count of them by removing member references from lenses
        disable_member_code_lens = true,
        -- JSXCloseTag
        -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-auto-tag,
        -- that maybe have a conflict if enable this feature. )
        jsx_close_tag = {
          enable = false,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ansible-language-server",
        "bash-language-server",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "gopls",
        "html-lsp",
        "intelephense",
        "lua-language-server",
        "prettier",
        "rust-analyzer",
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
