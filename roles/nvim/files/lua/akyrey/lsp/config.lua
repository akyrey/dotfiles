local utils = require("akyrey.lsp.utils")

local M = {}

---@type lspconfig.options
M.server = {
    angularls = {},
    ansiblels = {},
    bashls = {},
    dockerls = {},
    gopls = {
        settings = {
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true
            },
        },
    },
    jsonls = {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
            validate = {
                enable = true,
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = { globals = { 'vim' } },
                hint = { enable = true },
                telemetry = { enable = false },
                workspace = { checkThirdParty = false },
                completion = { callSnippet = "Replace" },
            },
        },
    },
    rust_analyzer = {},
    tailwindcss = {
        settings = {
            tailwindCSS = {
                lint = {
                    cssConflict = "warning",
                    invalidApply = "error",
                    invalidConfigPath = "error",
                    invalidScreen = "error",
                    invalidTailwindDirective = "error",
                    invalidVariant = "error",
                    recommendedVariantOrder = "warning"
                },
                validate = true,
            },
        },
    },
    tsserver = {
        -- Use this to add any additional keymaps for specific lsp servers
        ---@type Keymaps[]
        keys = {
            { keys = "<leader>go", func = "<cmd>TypescriptOrganizeImports<CR>", desc = "Or[g]anize Imp[o]rts" },
        },
        settings = {
            javascript = {
                inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
            typescript = {
                inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
        },
    },
    yamlls = {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
            new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
            vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
        end,
        settings = {
            completion = true,
            hover = true,
            schemaStore = {
                enable = false,
            },
            validate = true,
        },
    },
}

return M
