local function init()
  require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'always';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
      -- Built-in
      buffer = true;
      calc = true;
      path = true;
      spell = true;
      tags = true;

      -- Neovim
      nvim_lsp = true;
      nvim_lua = true;

      -- External plugin
      treesitter = true;

      -- External source
      tabnine = true;
    };
  }

  vim.o.completeopt = "menuone,noselect"

  local map = vim.api.nvim_set_keymap
  map("i", "<C-Space>", "compe#complete()", {expr = true})
  map("i", "<CR>", "compe#confirm(luaeval(\"require 'nvim-autopairs'.autopairs_cr()\"))", {expr = true})
  map("i", "<C-e>", "compe#close('<C-e>')", {expr = true})
  map("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {expr = true})
  map("i", "<C-d>", "compe#scroll({ 'delta': -4 })", {expr = true})

  --vim.cmd("highlight link CompeDocumentation NormalFloat")
end

return {
  init = init
}
