local utils = {}
local Log = require "core.log"
local uv = vim.loop

-- recursive Print (structure, limit, separator)
local function r_inspect_settings(structure, limit, separator)
  limit = limit or 100 -- default item limit
  separator = separator or "." -- indent string
  if limit < 1 then
    print "ERROR: Item limit reached."
    return limit - 1
  end
  if structure == nil then
    io.write("-- O", separator:sub(2), " = nil\n")
    return limit - 1
  end
  local ts = type(structure)

  if ts == "table" then
    for k, v in pairs(structure) do
      -- replace non alpha keys with ["key"]
      if tostring(k):match "[^%a_]" then
        k = '["' .. tostring(k) .. '"]'
      end
      limit = r_inspect_settings(v, limit, separator .. "." .. tostring(k))
      if limit < 0 then
        break
      end
    end
    return limit
  end

  if ts == "string" then
    -- escape sequences
    structure = string.format("%q", structure)
  end
  separator = separator:gsub("%.%[", "%[")
  if type(structure) == "function" then
    -- don't print functions
    io.write("-- akyrey", separator:sub(2), " = function ()\n")
  else
    io.write("akyrey", separator:sub(2), " = ", tostring(structure), "\n")
  end
  return limit - 1
end

utils.generate_settings = function()
  -- Opens a file in append mode
  local file = io.open("akyrey-settings.lua", "w")

  -- sets the default output file as test.lua
  io.output(file)

  -- write all `akyrey` related settings to `lv-settings.lua` file
  r_inspect_settings(akyrey, 10000, ".")

  -- closes the open file
  io.close(file)
end

-- autoformat
utils.toggle_autoformat = function()
  if akyrey.format_on_save then
    require("core.autocmds").define_augroups {
      autoformat = {
        {
          "BufWritePre",
          "*",
          ":silent lua vim.lsp.buf.formatting_sync()",
        },
      },
    }
    if Log:get_default() then
      Log:get_default().info "Format on save active"
    end
  end

  if not akyrey.format_on_save then
    vim.cmd [[
      if exists('#autoformat#BufWritePre')
        :autocmd! autoformat
      endif
    ]]
    if Log:get_default() then
      Log:get_default().info "Format on save off"
    end
  end
end

utils.reload_lv_config = function()
  vim.cmd "source ~/.config/nvim/lua/config.lua"
  vim.cmd "source ~/.config/nvim/lua/config-lang.lua"
  vim.cmd "source ~/.config/nvim/lua/settings.lua"
  require("keymappings").setup() -- this should be done before loading the plugins
  vim.cmd "source ~/.config/nvim/lua/plugins.lua"
  local plugins = require "plugins"
  local plugin_loader = require("plugin-loader").init()
  utils.toggle_autoformat()
  plugin_loader:load { plugins, akyrey.plugins }
  vim.cmd ":PackerCompile"
  vim.cmd ":PackerInstall"
  -- vim.cmd ":PackerClean"
  local null_ls = require "lsp.null-ls"
  null_ls.setup(vim.bo.filetype, { force_reload = true })

  Log:get_default().info "Reloaded configuration"
end

utils.unrequire = function(m)
  package.loaded[m] = nil
  _G[m] = nil
end

utils.gsub_args = function(args)
  if args == nil or type(args) ~= "table" then
    return args
  end
  local buffer_filepath = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
  for i = 1, #args do
    args[i] = string.gsub(args[i], "${FILEPATH}", buffer_filepath)
  end
  return args
end

--- Checks whether a given path exists and is a file.
--@param filename (string) path to check
--@returns (bool)
utils.is_file = function(filename)
  local stat = uv.fs_stat(filename)
  return stat and stat.type == "file" or false
end

-- Quickfix navigation
local use_global_quick_list = true
local open_QF = false

utils.toggle_global_or_local_QF = function()
  if use_global_quick_list then
    use_global_quick_list = false
    print('Using local quickfix list')
  else
    use_global_quick_list = true
    print('Using global quickfix list')
  end
end

utils.toggle_QF = function()
  if use_global_quick_list then
    if open_QF then
      vim.cmd([[cclose]])
      open_QF = false
    else
      vim.cmd([[copen]])
      open_QF = true
    end
  else
    if open_QF then
      vim.cmd([[lclose]])
      open_QF = false
    else
      vim.cmd([[lopen]])
      open_QF = true
    end
  end
end

utils.navigate_QF = function(next)
  if use_global_quick_list then
    if next then
      vim.cmd([[cnext]])
    else
      vim.cmd([[cprev]])
    end
  else
    if next then
      vim.cmd([[lnext]])
    else
      vim.cmd([[lprev]])
    end
  end
end

return utils
