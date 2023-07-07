local utils = require("akyrey.lsp.utils")

local M = {}

--  This function gets run when an LSP connects to a particular buffer.
local function common_on_attach(client, bufnr)
    utils.setup_document_highlight(client, bufnr)
    utils.setup_codelens_refresh(client, bufnr)
    utils.add_lsp_buffer_keybindings(bufnr)
    utils.add_lsp_buffer_options(bufnr)
    utils.setup_document_symbols(client, bufnr)
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
-- If additional configuration must be performed, use the extra_handlers below
M.servers = {
    angularls = {},
    ansiblels = {},
    bashls = {},
    dockerls = {},
    gopls = {
        gopls = {
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
        schemas = require("schemastore").json.schemas(),
        validate = {
            enable = true,
        },
    },
    lua_ls = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            hint = {
                enable = true,
            },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
        },
    },
    rust_analyzer = {},
    tailwindcss = {
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
    tsserver = {
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
    yamlls = {
        hover = true,
        completion = true,
        validate = true,
        schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemas = {
            kubernetes = {
                "daemon.{yml,yaml}",
                "manager.{yml,yaml}",
                "restapi.{yml,yaml}",
                "role.{yml,yaml}",
                "role_binding.{yml,yaml}",
                "*onfigma*.{yml,yaml}",
                "*ngres*.{yml,yaml}",
                "*ecre*.{yml,yaml}",
                "*eployment*.{yml,yaml}",
                "*ervic*.{yml,yaml}",
                "kubectl-edit*.yaml",
            },
        },
    },
}

-- You can provide a dedicated handler for specific servers.
local extra_handlers = {
    ["rust_analyzer"] = function()
        require("rust-tools").setup({
            server = {
                on_attach = function(_, bufnr)
                    utils.add_lsp_buffer_keybindings(bufnr)
                end,
            },
        })
    end,
    tsserver = function()
        require("lspconfig").tsserver.setup {
            capabilities = utils.common_capabilities(),
            on_attach = common_on_attach,
            settings = M.servers.tsserver,
            commands = {
                OrganizeImports = {
                    utils.organize_imports,
                    description = "Organize imports",
                },
            },
        }
    end,
}

local default_handler = {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler
        require("lspconfig")[server_name].setup {
            capabilities = utils.common_capabilities(),
            on_attach = common_on_attach,
            settings = M.servers[server_name],
        }
    end,
}

M.handlers = vim.tbl_deep_extend("force", default_handler, extra_handlers)

return M
