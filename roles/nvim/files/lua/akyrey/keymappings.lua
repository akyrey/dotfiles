local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
}

-- Append key mappings to akyrey's defaults for a given mode
-- @param keymaps The table of key mappings containing a list per mode (normal_mode, insert_mode, ..)
M.append_to_defaults = function(keymaps)
  for mode, mappings in pairs(keymaps) do
    for k, v in ipairs(mappings) do
      akyrey.keys[mode][k] = v
    end
  end
end

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
M.set_keymaps = function(mode, key, val)
  local opt = generic_opts[mode] and generic_opts[mode] or generic_opts_any
  if type(val) == "table" then
    opt = val[2]
    val = val[1]
  end
  vim.api.nvim_set_keymap(mode, key, val, opt)
end

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
M.load_mode = function(mode, keymaps)
  mode = mode_adapters[mode] and mode_adapters[mode] or mode
  for k, v in pairs(keymaps) do
    M.set_keymaps(mode, k, v)
  end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
M.load = function(keymaps)
  for mode, mapping in pairs(keymaps) do
    M.load_mode(mode, mapping)
  end
end

M.config = function()
  akyrey.keys = {
    ---@usage change or add keymappings for insert mode
    insert_mode = {
      -- 'jk' for quitting insert mode
      ["jk"] = "<ESC>",
      -- 'kj' for quitting insert mode
      ["kj"] = "<ESC>",
      -- 'jj' for quitting insert mode
      ["jj"] = "<ESC>",
      -- Undo break points
      [","] = ",<c-g>u",
      ["."] = ".<c-g>u",
      ["!"] = "!<c-g>u",
      ["?"] = "?<c-g>u",
      -- Moving text
      ["<C-j>"] = "<esc>:m .+1<CR>V",
      ["<C-k>"] = "<esc>:m .-2<CR>V",
    },

    ---@usage change or add keymappings for normal mode
    normal_mode = {
      -- Y will yank from cursor until the end of the line instead of entire line
      ["Y"] = "y$",
      -- Keeping cursor centered on search operations
      ["n"] = "nzzzv",
      ["N"] = "Nzzzv",
      ["J"] = "mzJ`z",
      -- Jumplist update on relative motions
      ["k"] = { "(v:count > 5 ? 'm`' . v:count : '') . 'k'", { noremap = true, expr = true, silent = true }},
      ["j"] = { "(v:count > 5 ? 'm`' . v:count : '') . 'j'", { noremap = true, expr = true, silent = true }},
      -- Moving text
      ["<leader>j"] = ":m .+1<CR>==",
      ["<leader>k"] = ":m .-2<CR>==",
      -- ------------------- --
      --      Navigation     --
      -- ------------------- --
      ["<C-q>"] = "<CMD>call QuickFixToggle()<CR>",
      -- ------------------- --
      --    File explorer    --
      -- ------------------- --
      ["<leader>e"] = "<CMD>Ex<CR>",
      ["<leader>u"] = "<CMD>UndotreeToggle<CR>",
      -- ------------------- --
      --      Telescope      --
      -- ------------------- --
      -- Fuzzy search through the output of git ls-files command, respects .gitignore, optionally ignores untracked files
      ["<C-f>"] = "<CMD>lua require('telescope.builtin').git_files()<CR>",
    },

    ---@usage change or add keymappings for terminal mode
    term_mode = {
    },

    ---@usage change or add keymappings for visual mode
    visual_mode = {
      -- Moving text
      ["J"] = ":m '>+1<CR>gv=gv",
      ["K"] = ":m '<-2<CR>gv=gv",
    },

    ---@usage change or add keymappings for visual block mode
    visual_block_mode = {
      -- Move selected line / block of text in visual mode
      ["J"] = ":move '>+1<CR>gv-gv",
      ["K"] = ":move '<-2<CR>gv-gv",
    },

    ---@usage change or add keymappings for command mode
    command_mode = {
      ['%%'] = { "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { noremap = true, expr = true }},
    },
  }
end

M.print = function(mode)
  print "List of keymappings (not including which-key)"
  if mode then
    print(vim.inspect(akyrey.keys[mode]))
  else
    print(vim.inspect(akyrey.keys))
  end
end

M.setup = function()
  vim.g.mapleader = akyrey.leader
  M.load(akyrey.keys)
end

return M

