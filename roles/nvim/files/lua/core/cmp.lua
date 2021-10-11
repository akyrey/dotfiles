local M = {}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' ~= nil
end

local vim_item_symbol = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

M.config = function()
  local Log = require "core.log"
  local status_ok, cmp = pcall(require, "cmp")
  if not status_ok then
    return
  end

  local status_luasnip, luasnip = pcall(require, "luasnip")
  if not status_luasnip then
    return
  end

  akyrey.builtin.cmp = {
    completion = {
      completeopt = "menu,menuone,noinsert",
    },

    documentation = {
      border = "single",
      winhighlight = "NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
      maxwidth = 120,
      maxheight = math.floor(vim.o.lines * 0.3),
    },

    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = vim_item_symbol[vim_item.kind]
          .. " "
          .. vim_item.kind
        -- set a name for each source
        vim_item.menu = ({
          buffer = "   (Buffer)",
          nvim_lsp = "   (LSP)",
          luasnip = "   (Snippet)",
          nvim_lua = "   (Lua)",
          cmp_tabnine = " ♖  (T9)",
          path = "   (Path)",
          spell = "   (Spell)",
          calc = "   (Calc)",
        })[entry.source.name]
        return vim_item;
      end
    },

    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, {
          "i",
          "s",
        }),
      ["<S-tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, {
          "i",
          "s",
        }),
    },

    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end
    },

    sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "cmp_tabnine" },
      { name = "luasnip" },
      { name = "path" },
      { name = "spell" },
    },
  }
end

M.setup = function()
  local Log = require "core.log"
  local status_ok, cmp = pcall(require, "cmp")
  if not status_ok then
    Log:get_default().error "failed to load cmp"
    return
  end

  cmp.setup(akyrey.builtin.cmp)
end

return M

