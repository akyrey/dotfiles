-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/akyrey/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/akyrey/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/akyrey/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/akyrey/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/akyrey/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24akyrey.core.comment\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/LuaSnip"
  },
  ["barbar.nvim"] = {
    config = { "\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\27akyrey.core.bufferline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/barbar.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-npm"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/cmp-npm"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/cmp-spell"
  },
  ["cmp-tabnine"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/cmp-tabnine"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/cmp_luasnip"
  },
  ["friendly-snippets"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/friendly-snippets"
  },
  ["git-worktree.nvim"] = {
    config = { "\27LJ\2\nF\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\29akyrey.core.git-worktree\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/git-worktree.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25akyrey.core.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim"
  },
  gruvbox = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/gruvbox"
  },
  ["gv.vim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/gv.vim"
  },
  harpoon = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/harpoon"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24akyrey.core.lualine\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["nlsp-settings.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nlsp-settings.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\26akyrey.core.autopairs\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20akyrey.core.cmp\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\26akyrey.core.colorizer\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-notify"
  },
  ["nvim-toggleterm.lua"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25akyrey.core.terminal\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-toggleterm.lua"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25akyrey.core.nvimtree\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\27akyrey.core.treesitter\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["refactoring.nvim"] = {
    config = { "\27LJ\2\nE\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\28akyrey.core.refactoring\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/refactoring.nvim"
  },
  ["structlog.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/structlog.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\26akyrey.core.telescope\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\nG\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\30akyrey.core.todo-comments\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/todo-comments.nvim"
  },
  undotree = {
    commands = { "UndotreeToggle" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/undotree"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-wakatime"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/vim-wakatime"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\26akyrey.core.which-key\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\nG\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\30akyrey.core.todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25akyrey.core.nvimtree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\26akyrey.core.autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24akyrey.core.lualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\26akyrey.core.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: git-worktree.nvim
time([[Config for git-worktree.nvim]], true)
try_loadstring("\27LJ\2\nF\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\29akyrey.core.git-worktree\frequire\0", "config", "git-worktree.nvim")
time([[Config for git-worktree.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20akyrey.core.cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\26akyrey.core.colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\27akyrey.core.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UndotreeToggle lua require("packer.load")({'undotree'}, { cmd = "UndotreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufWinEnter * ++once lua require("packer.load")({'which-key.nvim', 'nvim-toggleterm.lua', 'barbar.nvim'}, { event = "BufWinEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'Comment.nvim', 'gitsigns.nvim', 'refactoring.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au InsertCharPre * ++once lua require("packer.load")({'friendly-snippets'}, { event = "InsertCharPre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
