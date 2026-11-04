-- projector (https://github.com/akyrey/projector) integration for overseer.
--
-- projector resolves named commands from ~/.config/projector/config.yaml and
-- every .projector.yaml walking up from the cwd, so it already knows each
-- project's start/test/lint/artisan commands and their docker quirks. This
-- exposes those commands as overseer tasks instead of re-declaring them here.
--
-- projector has no machine-readable listing, so command names come from its
-- shell-completion endpoint (one name per line, aliases included) and the
-- descriptions and aliases from the human-readable `projector list`.
local M = {}

local CONFIG_FILE = ".projector.yaml"

---@class projector.Command
---@field name string
---@field desc? string

---@param dir string
---@return string|nil
local function config_path(dir)
  return vim.fs.find(CONFIG_FILE, { upward = true, path = dir })[1]
end

--- Command names offered by completion, minus cobra's trailing ":<directive>".
---@param stdout string
---@return string[]
local function parse_names(stdout)
  local names = {}
  for line in vim.gsplit(stdout, "\n", { plain = true }) do
    local name = line:match("^([^\t:][^\t]*)")
    if name then
      table.insert(names, name)
    end
  end
  return names
end

--- Descriptions and alias names from `projector list`. Top-level entries are
--- "  <name>  <description>"; aliases sit on an indented "aliases: [a, b]" line.
---@param stdout string
---@return table<string, string> descriptions, table<string, boolean> aliases
local function parse_list(stdout)
  local descriptions, aliases = {}, {}
  for line in vim.gsplit(stdout, "\n", { plain = true }) do
    local alias_list = line:match("^%s+aliases: %[(.*)%]%s*$")
    if alias_list then
      for alias in alias_list:gmatch("[^,%s]+") do
        aliases[alias] = true
      end
    else
      local name, desc = line:match("^  (%S+)%s%s+(.+)$")
      if name and descriptions[name] == nil then
        descriptions[name] = desc
      end
    end
  end
  return descriptions, aliases
end

--- Resolve projector's commands for a directory, aliases filtered out.
---@param dir string
---@param cb fun(err: string|nil, commands: projector.Command[]|nil)
function M.commands(dir, cb)
  if vim.fn.executable("projector") == 0 then
    cb('Command "projector" not found')
    return
  end
  vim.system({ "projector", "__complete", "run", "" }, { cwd = dir, text = true }, function(names_out)
    if names_out.code ~= 0 then
      cb("projector completion failed: " .. (names_out.stderr or ""))
      return
    end
    vim.system({ "projector", "list" }, { cwd = dir, text = true }, function(list_out)
      if list_out.code ~= 0 then
        cb("projector list failed: " .. (list_out.stderr or ""))
        return
      end
      local descriptions, aliases = parse_list(list_out.stdout or "")
      local commands = {}
      for _, name in ipairs(parse_names(names_out.stdout or "")) do
        if not aliases[name] then
          table.insert(commands, { name = name, desc = descriptions[name] })
        end
      end
      table.sort(commands, function(a, b)
        return a.name < b.name
      end)
      cb(nil, commands)
    end)
  end)
end

---@param name string
---@param extra_args? string appended verbatim after `--`, shell quoting preserved
---@return string[]
local function run_cmd(name, extra_args)
  local cmd = { "projector", "run", name }
  if extra_args and vim.trim(extra_args) ~= "" then
    vim.list_extend(cmd, { "--", extra_args })
  end
  return cmd
end

--- Overseer template provider: one task per projector command.
---@type overseer.TemplateProvider
M.overseer_provider = {
  name = "projector",
  cache_key = function(opts)
    return config_path(opts.dir)
  end,
  generator = function(opts, cb)
    if not config_path(opts.dir) then
      return "No " .. CONFIG_FILE .. " found"
    end
    M.commands(opts.dir, function(err, commands)
      vim.schedule(function()
        if err then
          cb(err)
          return
        end
        cb(vim.tbl_map(function(command)
          return {
            name = "projector " .. command.name,
            desc = command.desc,
            builder = function()
              return { cmd = run_cmd(command.name), cwd = opts.dir }
            end,
          }
        end, commands))
      end)
    end)
  end,
}

--- Pick a projector command, ask for extra arguments, and run it in overseer.
--- Covers passthrough commands like `artisan` or `composer`, which need them.
function M.run_with_args()
  local dir = vim.uv.cwd()
  M.commands(dir, function(err, commands)
    vim.schedule(function()
      if err then
        vim.notify(err, vim.log.levels.ERROR, { title = "projector" })
        return
      end
      vim.ui.select(commands, {
        prompt = "projector command",
        format_item = function(command)
          return command.desc and (command.name .. "  " .. command.desc) or command.name
        end,
      }, function(command)
        if not command then
          return
        end
        vim.ui.input({ prompt = "projector " .. command.name .. " -- " }, function(extra_args)
          if extra_args == nil then
            return
          end
          local task = require("overseer").new_task({
            name = vim.trim("projector " .. command.name .. " " .. extra_args),
            cmd = run_cmd(command.name, extra_args),
            cwd = dir,
          })
          task:start()
        end)
      end)
    end)
  end)
end

return M
