-- LSP wiring: diagnostics, per-buffer keymaps, and which servers to enable.
-- Server settings themselves live one-per-file in lsp/*.lua, which Neovim
-- resolves off the runtimepath when vim.lsp.enable() names them.

-- ---------------------------------------------------------------------------
-- Diagnostics
-- ---------------------------------------------------------------------------

vim.diagnostic.config({
  severity_sort = true,
  underline = { severity = vim.diagnostic.severity.ERROR },
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
    -- Append the diagnostic code, e.g. "Undefined variable [P1013]".
    format = function(d)
      local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code)
      if code then
        return (string.format("%s [%s]", d.message, code):gsub("1%. ", ""))
      end
      return d.message
    end,
  },
})

-- Dim text tagged "unnecessary" (e.g. intelephense's unused-variable/import
-- hints) regardless of severity, since `underline` above is restricted to
-- errors and would otherwise never reach hint-level diagnostics.
local unnecessary_ns = vim.api.nvim_create_namespace("akyrey_diagnostic_unnecessary")

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = vim.api.nvim_create_augroup("akyrey_diagnostic_unnecessary", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    vim.api.nvim_buf_clear_namespace(bufnr, unnecessary_ns, 0, -1)
    for _, d in ipairs(event.data.diagnostics) do
      if d._tags and d._tags.unnecessary then
        vim.hl.range(bufnr, unnecessary_ns, "DiagnosticUnnecessary", { d.lnum, d.col }, { d.end_lnum, d.end_col })
      end
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Capabilities
-- ---------------------------------------------------------------------------

-- Requiring blink here loads it via lazy.nvim's module loader, which is what we
-- want: capabilities have to be known before the first client starts.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
})

-- ---------------------------------------------------------------------------
-- Per-buffer keymaps and features
-- ---------------------------------------------------------------------------

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("akyrey_lsp_attach", { clear = true }),
  callback = function(event)
    local buf = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "LSP: " .. desc })
    end

    -- Navigation goes through the picker so results are fuzzy-filterable.
    local picker = function(name)
      return function()
        Snacks.picker[name]()
      end
    end

    map("n", "gd", picker("lsp_definitions"), "Goto definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
    map("n", "gr", picker("lsp_references"), "References")
    map("n", "gI", picker("lsp_implementations"), "Goto implementation")
    map("n", "gy", picker("lsp_type_definitions"), "Goto type definition")
    map("n", "<leader>ss", picker("lsp_symbols"), "Document symbols")
    map("n", "<leader>sS", picker("lsp_workspace_symbols"), "Workspace symbols")

    map("n", "K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, "Hover")
    map("n", "gK", function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end, "Signature help")
    map("i", "<c-k>", function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end, "Signature help")

    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>cR", function()
      Snacks.rename.rename_file()
    end, "Rename file")

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      map("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
      end, "Toggle inlay hints")
    end

    if client:supports_method("textDocument/documentHighlight") then
      local group = vim.api.nvim_create_augroup("akyrey_lsp_highlight_" .. buf, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = buf,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = buf,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Enabled servers (each has a matching lsp/<name>.lua)
-- ---------------------------------------------------------------------------

vim.lsp.enable({
  "ansiblels",
  "bashls",
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "emmet_ls",
  "gopls",
  "html",
  "intelephense",
  "jsonls",
  "koseven_lsp",
  "laravel_lsp",
  "lua_ls",
  "tailwindcss",
  "vtsls",
  "yamlls",
})
