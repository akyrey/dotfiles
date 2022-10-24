local M = {}
local Log = require "akyrey.core.log"
local utils = require "akyrey.utils"
local autocmds = require "akyrey.core.autocmds"

local function add_lsp_helper_commands()
  local cmd = vim.cmd
  cmd("command! LspDec lua vim.lsp.buf.declaration()")
  cmd("command! LspDef lua vim.lsp.buf.definition()")
  cmd("command! LspFormat lua require('akyrey.lsp.utils').format()")
  cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  cmd("command! LspHover lua vim.lsp.buf.hover()")
  cmd("command! LspRename lua vim.lsp.buf.rename()")
  cmd("command! LspOrganize lua lsp_organize_imports()")
  cmd("command! LspRefs lua vim.lsp.buf.references()")
  cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
  cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
  cmd("command! LspDiagLine lua require('akyrey.lsp.handlers').show_line_diagnostics()")
  cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
end

local function add_lsp_buffer_options(bufnr)
  for k, v in pairs(akyrey.lsp.buffer_options) do
    vim.api.nvim_buf_set_option(bufnr, k, v)
  end
end

local function add_lsp_buffer_keybindings(bufnr)
  local mappings = {
    normal_mode = "n",
    insert_mode = "i",
    visual_mode = "v",
  }

  if akyrey.builtin.which_key.active then
    -- Remap using which_key
    local status_ok, wk = pcall(require, "which-key")
    if not status_ok then
      return
    end
    for mode_name, mode_char in pairs(mappings) do
      wk.register(akyrey.lsp.buffer_mappings[mode_name], { mode = mode_char, buffer = bufnr })
    end
  else
    -- Remap using nvim api
    for mode_name, mode_char in pairs(mappings) do
      for key, remap in pairs(akyrey.lsp.buffer_mappings[mode_name]) do
        vim.api.nvim_buf_set_keymap(bufnr, mode_char, key, remap[1], { noremap = true, silent = true })
      end
    end
  end
end

function M.common_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
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

function M.common_on_exit(_, _)
  if akyrey.lsp.document_highlight then
    autocmds.clear_augroup "lsp_document_highlight"
  end
  if akyrey.lsp.code_lens_refresh then
    autocmds.clear_augroup "lsp_code_lens_refresh"
  end
end

function M.common_on_init(client, bufnr)
  if akyrey.lsp.on_init_callback then
    akyrey.lsp.on_init_callback(client, bufnr)
    Log:debug "Called lsp.on_init_callback"
    return
  end
end

function M.common_on_attach(client, bufnr)
  if akyrey.lsp.on_attach_callback then
    akyrey.lsp.on_attach_callback(client, bufnr)
    Log:debug "Called lsp.on_attach_callback"
  end
  local lu = require "akyrey.lsp.utils"
  if akyrey.lsp.document_highlight then
    lu.setup_document_highlight(client, bufnr)
  end
  if akyrey.lsp.code_lens_refresh then
    lu.setup_codelens_refresh(client, bufnr)
  end
  add_lsp_helper_commands()
  add_lsp_buffer_keybindings(bufnr)
  add_lsp_buffer_options(bufnr)
  lu.setup_document_symbols(client, bufnr)
end

function M.get_common_opts()
  return {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
  }
end

function M.setup()
  Log:debug "Setting up LSP support"

  local lsp_status_ok, _ = pcall(require, "lspconfig")
  if not lsp_status_ok then
    return
  end

  for _, sign in ipairs(akyrey.lsp.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  require("akyrey.lsp.handlers").setup()

  if not utils.is_directory(akyrey.lsp.templates_dir) then
    require("akyrey.lsp.templates").generate_templates()
  end

  pcall(function()
    require("nlspsettings").setup(akyrey.lsp.nlsp_settings.setup)
  end)

  pcall(function()
    require("mason-lspconfig").setup(akyrey.lsp.installer.setup)
    local util = require "lspconfig.util"
    -- automatic_installation is handled by lsp-manager
    util.on_setup = nil
  end)

  require("akyrey.lsp.null-ls").setup()

  autocmds.configure_format_on_save()
end

return M
