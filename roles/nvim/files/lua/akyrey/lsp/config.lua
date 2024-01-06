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
            gopls = {
                gofumpt = true,
                codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                analyses = {
                    fieldalignment = true,
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                semanticTokens = true,
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
    intelephense = {},
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
