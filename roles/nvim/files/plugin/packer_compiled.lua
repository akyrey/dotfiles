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
  LuaSnip = {
    config = { "\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\27akyrey.plugins.luasnip\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    wants = { "friendly-snippets" }
  },
  ["compe-tabnine"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/compe-tabnine"
  },
  ["friendly-snippets"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/friendly-snippets"
  },
  ["git-worktree.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit akyrey.plugins.git-worktree\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/git-worktree.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\28akyrey.plugins.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim"
  },
  ["gv.vim"] = {
    load_after = {
      ["vim-fugitive"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/gv.vim"
  },
  harpoon = {
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/harpoon"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    commands = { "Lspsaga" },
    config = { "\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\27akyrey.plugins.lspsaga\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/lspsaga.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\nC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\27akyrey.plugins.lualine\frequire\0" },
    load_after = {
      ["material.vim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/lualine.nvim"
  },
  ["material.vim"] = {
    after = { "lualine.nvim", "nvim-colorizer.lua", "nvim-bufferline.lua", "package-info.nvim", "vim-wakatime" },
    config = { "\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\28akyrey.plugins.material\frequire\0" },
    load_after = {
      ["packer.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/material.vim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\nE\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\29akyrey.plugins.autopairs\frequire\0" },
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-autopairs"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\nF\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\30akyrey.plugins.bufferline\frequire\0" },
    load_after = {
      ["material.vim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\nE\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\29akyrey.plugins.colorizer\frequire\0" },
    load_after = {
      ["material.vim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    after = { "nvim-autopairs" },
    after_files = { "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\2\n\1\0\0\3\0\5\0\0166\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\4\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\27akyrey.plugins.lspkind!akyrey.plugins.compe_tabnine\tinit\25akyrey.plugins.compe\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-compe",
    wants = { "LuaSnip" }
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29akyrey.plugins.lspconfig\frequire\0" },
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle" },
    config = { "\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\28akyrey.plugins.nvimtree\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "todo-comments.nvim" },
    config = { "\27LJ\2\nF\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\30akyrey.plugins.treesitter\frequire\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["package-info.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit akyrey.plugins.package-info\frequire\0" },
    load_after = {
      ["material.vim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/package-info.nvim"
  },
  ["packer.nvim"] = {
    after = { "material.vim" },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    after = { "harpoon" },
    loaded = true,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/popup.nvim"
  },
  ["symbols-outline.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/symbols-outline.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nE\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit\29akyrey.plugins.telescope\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\nI\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit!akyrey.plugins.todo-comments\frequire\0" },
    load_after = {
      ["nvim-treesitter"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/todo-comments.nvim"
  },
  ["vim-commentary"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/vim-commentary"
  },
  ["vim-fugitive"] = {
    after = { "gv.vim" },
    loaded = false,
    needs_bufread = true,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-wakatime"] = {
    load_after = {
      ["material.vim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/akyrey/.local/share/nvim/site/pack/packer/opt/vim-wakatime"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^harpoon"] = "harpoon",
  lspsaga = "lspsaga.nvim",
  telescope = "telescope.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29akyrey.plugins.lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: git-worktree.nvim
time([[Config for git-worktree.nvim]], true)
try_loadstring("\27LJ\2\nH\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tinit akyrey.plugins.git-worktree\frequire\0", "config", "git-worktree.nvim")
time([[Config for git-worktree.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd popup.nvim ]]
time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Lspsaga lua require("packer.load")({'lspsaga.nvim'}, { cmd = "Lspsaga", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'gitsigns.nvim', 'nvim-treesitter', 'vim-commentary', 'vim-fugitive', 'nvim-treesitter-context'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au InsertCharPre * ++once lua require("packer.load")({'friendly-snippets', 'LuaSnip'}, { event = "InsertCharPre *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'packer.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
