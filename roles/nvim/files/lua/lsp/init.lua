local M = {}
local Log = require "core.log"

-- Global organize imports command
_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

M.config = function()
  vim.lsp.protocol.CompletionItemKind = akyrey.lsp.completion.item_kind

  for _, sign in ipairs(akyrey.lsp.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  require("lsp.handlers").setup()
end

local function lsp_highlight_document(client)
  if akyrey.lsp.document_highlight == false then
    return -- we don't need further
  end
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local function add_lsp_helper_commands()
  local cmd = vim.cmd
  cmd("command! LspDec lua vim.lsp.buf.declaration()")
  cmd("command! LspDef lua vim.lsp.buf.definition()")
  cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  cmd("command! LspHover lua vim.lsp.buf.hover()")
  cmd("command! LspRename lua vim.lsp.buf.rename()")
  cmd("command! LspOrganize lua lsp_organize_imports()")
  cmd("command! LspRefs lua vim.lsp.buf.references()")
  cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
  cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
  cmd("command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
  cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
end

local function add_lsp_buffer_keybindings(bufnr)
  local wk = require "which-key"
  local keys = {
    ["<leader>gh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
    ["<leader>gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
    ["<leader>gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
    ["<leader>gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto references" },
    ["<leader>gi"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto implementation" },
    ["<leader>gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature help" },
    ["<leader>gc"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename references" },
    ["<leader>gp"] = { "<cmd>lua require'lsp.peek'.Peek('definition')<CR>", "Peek definition" },
    ["<leader>gl"] = {
      "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ show_header = false, border = 'single' })<CR>",
      "Show line diagnostics",
    },
    ["<leader>go"] = { "<cmd>lua lsp_organize_imports()<CR>", "Organize imports" },
    ["<C-p>"] = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format code" }
  }
  wk.register(keys, { mode = "n", buffer = bufnr })
end

local function set_smart_cwd(client)
  local proj_dir = client.config.root_dir
  if akyrey.lsp.smart_cwd and proj_dir ~= "/" then
    vim.api.nvim_set_current_dir(proj_dir)
    require("core.nvimtree").change_tree_dir(proj_dir)
  end
end

M.common_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
  end
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  return capabilities
end

M.get_ls_capabilities = function(client_id)
  local client
  if not client_id then
    local buf_clients = vim.lsp.buf_get_clients()
    for _, buf_client in ipairs(buf_clients) do
      if buf_client.name ~= "null-ls" then
        client_id = buf_client.id
        break
      end
    end
  end
  if not client_id then
    error "Unable to determine client_id"
  end

  client = vim.lsp.get_client_by_id(tonumber(client_id))

  local enabled_caps = {}

  for k, v in pairs(client.resolved_capabilities) do
    if v == true then
      table.insert(enabled_caps, k)
    end
  end

  return enabled_caps
end

M.common_on_init = function(client, bufnr)
  if akyrey.lsp.on_init_callback then
    akyrey.lsp.on_init_callback(client, bufnr)
    Log:get_default().info "Called lsp.on_init_callback"
    return
  end

  local formatters = akyrey.lang[vim.bo.filetype].formatters
  if not vim.tbl_isempty(formatters) and formatters[1]["exe"] ~= nil and formatters[1].exe ~= "" then
    client.resolved_capabilities.document_formatting = false
    Log:get_default().info(
      string.format("Overriding language server [%s] with format provider [%s]", client.name, formatters[1].exe)
    )
  end
end

M.common_on_attach = function(client, bufnr)
  if akyrey.lsp.on_attach_callback then
    akyrey.lsp.on_attach_callback(client, bufnr)
    Log:get_default().info "Called lsp.on_init_callback"
  end
  lsp_highlight_document(client)
  add_lsp_helper_commands()
  add_lsp_buffer_keybindings(bufnr)
  set_smart_cwd(client)
  require("lsp.null-ls").setup(vim.bo.filetype)
end

M.setup = function(lang)
  local lsp_utils = require "lsp.utils"
  local lsp = akyrey.lang[lang].lsp
  if lsp_utils.is_client_active(lsp.provider) then
    return
  end

  local overrides = akyrey.lsp.override
  if type(overrides) == "table" then
    if vim.tbl_contains(overrides, lang) then
      return
    end
  end

  if lsp.provider ~= nil and lsp.provider ~= "" then
    local lspconfig = require "lspconfig"
    lspconfig[lsp.provider].setup(lsp.setup)
  end
end

return M
