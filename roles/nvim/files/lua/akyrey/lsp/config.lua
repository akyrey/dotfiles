local skipped_servers = {
  "ccls",
  "csharp_ls",
  "cssmodules_ls",
  "denols",
  "ember",
  "emmet_ls",
  "eslintls",
  "golangci_lint_ls",
  "jedi_language_server",
  "ltex",
  "ocamlls",
  "phpactor",
  "psalm",
  "pylsp",
  "quick_lint_js",
  "rome",
  "reason_ls",
  "scry",
  "solang",
  "solidity_ls",
  "sorbet",
  "sourcekit",
  "sourcery",
  "spectral",
  "sqlls",
  "sqls",
  "stylelint_lsp",
  "tflint",
  "verible",
  "vuels",
}

local skipped_filetypes = { "markdown", "rst", "plaintext" }

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
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      format = function(d)
        local t = vim.deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
        end
        return t.message
      end,
    },
  },
  document_highlight = true,
  code_lens_refresh = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  },
  peek = {
    max_height = 15,
    max_width = 30,
    context = 10,
  },
  on_attach_callback = nil,
  on_init_callback = nil,
  automatic_servers_installation = true,
  automatic_configuration = {
    ---@usage list of servers that the automatic installer will skip
    skipped_servers = skipped_servers,
    ---@usage list of filetypes that the automatic installer will skip
    skipped_filetypes = skipped_filetypes,
  },
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
      ["<C-p>"] = { require("akyrey.lsp.utils").format, "Format code" }
    },
    insert_mode = {},
    visual_mode = {},
  },
  null_ls = {
    setup = {},
    config = {},
  },
  ---@deprecated use automatic_configuration.skipped_servers instead
  override = {},
}
