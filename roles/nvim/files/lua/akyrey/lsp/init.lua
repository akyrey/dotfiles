local M = {}
local Log = require "akyrey.core.log"
local utils = require "akyrey.utils"
local autocmds = require "akyrey.core.autocmds"

local function lsp_highlight_document(client)
  if akyrey.lsp.document_highlight == false then
    return -- we don't need further
  end
  -- Set autocommands conditional on server_capabilities
  autocmds.enable_lsp_document_highlight(client.id)
end

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

local function lsp_code_lens_refresh(client)
  if akyrey.lsp.code_lens_refresh == false then
    return
  end

  if client.server_capabilities.code_lens then
    autocmds.enable_code_lens_refresh()
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
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

local function select_default_formater(client)
  if client.name == "null-ls" or not client.server_capabilities.document_formatting then
    return
  end
  Log:debug("Checking for formatter overriding for " .. client.name)
  local formatters = require "akyrey.lsp.null-ls.formatters"
  local client_filetypes = client.config.filetypes or {}
  for _, filetype in ipairs(client_filetypes) do
    if #vim.tbl_keys(formatters.list_registered_providers(filetype)) > 0 then
      Log:debug("Formatter overriding detected. Disabling formatting capabilities for " .. client.name)
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
    end
  end
end

function M.common_on_exit(_, _)
  if akyrey.lsp.document_highlight then
    autocmds.disable_lsp_document_highlight()
  end
  if akyrey.lsp.code_lens_refresh then
    autocmds.disable_code_lens_refresh()
  end
end

function M.common_on_init(client, bufnr)
  if akyrey.lsp.on_init_callback then
    akyrey.lsp.on_init_callback(client, bufnr)
    Log:debug "Called lsp.on_init_callback"
    return
  end
  select_default_formater(client)
end

function M.common_on_attach(client, bufnr)
  if akyrey.lsp.on_attach_callback then
    akyrey.lsp.on_attach_callback(client, bufnr)
    Log:debug "Called lsp.on_attach_callback"
  end
  lsp_highlight_document(client)
  add_lsp_helper_commands()
  lsp_code_lens_refresh(client)
  add_lsp_buffer_keybindings(bufnr)
end

local function bootstrap_nlsp(opts)
  opts = opts or {}
  local lsp_settings_status_ok, lsp_settings = pcall(require, "nlspsettings")
  if lsp_settings_status_ok then
    lsp_settings.setup(opts)
  end
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

  for _, sign in ipairs(akyrey.lsp.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  require("akyrey.lsp.handlers").setup()

  if not utils.is_directory(akyrey.lsp.templates_dir) then
    require("akyrey.lsp.templates").generate_templates()
  end

  bootstrap_nlsp {
    config_home = utils.join_paths(get_config_dir(), "lsp-settings"),
    append_default_schemas = true,
  }

  require("nvim-lsp-installer").setup {
    -- use the default nvim_data_dir, since the server binaries are independent
    install_root_dir = utils.join_paths(vim.call("stdpath", "data"), "lsp_servers"),
  }

  require("akyrey.lsp.null-ls").setup()

  autocmds.configure_format_on_save()
end

return M
