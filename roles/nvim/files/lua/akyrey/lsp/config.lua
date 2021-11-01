-- Global organize imports command
_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

return {
  templates_dir = join_paths(get_runtime_dir(), "site", "after", "ftplugin"),
  diagnostics = {
    signs = {
      active = true,
      values = {
        { name = "LspDiagnosticsSignError", text = "" },
        { name = "LspDiagnosticsSignWarning", text = "" },
        { name = "LspDiagnosticsSignHint", text = "" },
        { name = "LspDiagnosticsSignInformation", text = "" },
      },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
  },
  document_highlight = true,
  code_lens_refresh = true,
  popup_border = "single",
  on_attach_callback = nil,
  on_init_callback = nil,
  automatic_servers_installation = true,
  buffer_mappings = {
    normal_mode = {
      ["<leader>gh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show hover" },
      ["<leader>gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
      ["<leader>gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
      ["<leader>gr"] = { "<cmd>lua vim.lsp.buf.references()<CR>", "Goto references" },
      ["<leader>gi"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
      ["<leader>gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "show signature help" },
      ["<leader>gc"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename references" },
      ["<leader>gp"] = { "<cmd>lua require'akyrey.lsp.peek'.Peek('definition')<CR>", "Peek definition" },
      ["<leader>gl"] = {
        "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ show_header = false, border = 'single' })<CR>",
        "Show line diagnostics",
      },
      ["<leader>go"] = { "<cmd>lua lsp_organize_imports()<CR>", "Organize imports" },
      ["<C-p>"] = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format code" }
    },
    insert_mode = {},
    visual_mode = {},
  },
  null_ls = {
    setup = {},
  },
  override = {
    "angularls",
    "ansiblels",
    "denols",
    "ember",
    "emmet_ls",
    "eslint",
    "eslintls",
    "graphql",
    "jedi_language_server",
    "ltex",
    "phpactor",
    "pylsp",
    "rome",
    "sqlls",
    "sqls",
    "stylelint_lsp",
    "tailwindcss",
    "tflint",
    "volar",
  },
}
