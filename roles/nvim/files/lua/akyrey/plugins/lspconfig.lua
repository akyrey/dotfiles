local on_attach = function(client, bufnr)
  local buf_map = vim.api.nvim_buf_set_keymap
  -- Define LSP helper commands
  vim.cmd("command! LspDec lua vim.lsp.buf.declaration()")
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspOrganize lua lsp_organize_imports()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
  vim.cmd("command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

  -- Define mappings
  buf_map(bufnr, "n", "<leader>gD", ":LspDec<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>gd", ":LspDef<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>grn", ":LspRename<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>grr", ":LspRefs<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>gtd", ":LspTypeDef<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>gh", ":LspHover<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>go", ":LspOrganize<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>gp", ":LspDiagPrev<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>gn", ":LspDiagNext<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>gca", ":LspCodeAction<CR>", {silent = true})
  buf_map(bufnr, "n", "<leader>gl", ":LspDiagLine<CR>", {silent = true})
  buf_map(bufnr, "i", "<leader>gsh", ":LspSignatureHelp<CR>", {silent = true})

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_map(bufnr, "n", "<C-p>", "<cmd>lua vim.lsp.buf.formatting()<CR>", {silent = true})
  elseif client.resolved_capabilities.document_range_formatting then
    buf_map(bufnr, "n", "<C-p>", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", {silent = true})
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
end

-- Configure diagnostic-languageserver to use ESLint
local filetypes = {
  typescript = "eslint",
  typescriptreact = "eslint",
}
local linters = {
  eslint = {
    sourceName = "eslint",
    command = "eslint_d",
    rootPatterns = {".eslintrc.js", "package.json"},
    debounce = 100,
    args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
    parseJson = {
      errorsRoot = "[0].messages",
      line = "line",
      column = "column",
      endLine = "endLine",
      endColumn = "endColumn",
      message = "${message} [${ruleId}]",
      security = "severity"
    },
    securities = {[2] = "error", [1] = "warning"}
  }
}
local formatters = {
  prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}
local formatFiletypes = {
  typescript = "prettier",
  typescriptreact = "prettier"
}

-- Configure lua language server for neovim development
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'},
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}

-- Configure angular language server for neovim development
local angularls_cmd = {"ngserver", "--stdio", "--tsProbeLocations", "node_modules" , "--ngProbeLocations", "node_modules"}

-- Override default formatting with custom
local format_async = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then return end
  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, bufnr)
    vim.fn.winrestview(view)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command("noautocmd :update")
    end
  end
end

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
    root_dir = vim.loop.cwd,
  }
end

local function setup_servers(lspconfig, lspinstall)
  lspinstall.setup()

  -- get all installed servers
  local servers = lspinstall.installed_servers()
  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == 'lua' then
      config.settings = lua_settings
    elseif server == 'tsserver' then
      config.on_attach = function(client)
        -- Formatting will be handled by Prettier
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
      end
    elseif server == 'diagnosticls' then
      config.filetypes = vim.tbl_keys(filetypes)
      config.init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes,
      }
    elseif server == 'angularls' then
        config.cmd = angularls_cmd
        config.on_new_config = function(new_config)
          new_config.cmd = angularls_cmd
      end
    end

    lspconfig[server].setup(config)
  end

  vim.cmd('LspStart')
end

local function init()
  local present1, lspconfig = pcall(require, "lspconfig")
  local present2, lspinstall = pcall(require, "lspinstall")

  if not (present1 or present2) then
    return
  end

  vim.lsp.handlers["textDocument/formatting"] = format_async

  -- Organize import like in VS Code
  _G.lsp_organize_imports = function()
    local params = {
      command = "_typescript.organizeImports",
      arguments = {vim.api.nvim_buf_get_name(0)},
      title = ""
    }
    vim.lsp.buf.execute_command(params)
  end

  setup_servers(lspconfig, lspinstall)

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  lspinstall.post_install_hook = function()
    setup_servers(lspconfig, lspinstall) -- reload installed servers
    vim.cmd("bufdo e") -- triggers FileType autocmd that starts the server
  end

  -- Replace the default lsp diagnostic symbols
  local function lspSymbol(name, icon)
    vim.fn.sign_define("LspDiagnosticsSign" .. name, {text = icon, numhl = "LspDiagnosticsDefaul" .. name})
  end

  lspSymbol("Error", "")
  lspSymbol("Warning", "")
  lspSymbol("Information", "")
  lspSymbol("Hint", "")
end

return {
  init = init,
}
