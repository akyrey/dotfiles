return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
  opts = {
    ---@type HarpoonSettings
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
      key = function()
        local Job = require("plenary.job")

        local function get_os_command_output(cmd, cwd)
          if type(cmd) ~= "table" then
            return {}
          end
          local command = table.remove(cmd, 1)
          local stderr = {}
          local stdout, ret = Job:new({
            command = command,
            args = cmd,
            cwd = cwd,
            on_stderr = function(_, data)
              table.insert(stderr, data)
            end,
          }):sync()
          return stdout, ret, stderr
        end

        -- Use git branch name if available
        local branch = get_os_command_output({
          "git",
          "rev-parse",
          "--abbrev-ref",
          "HEAD",
        })[1]

        if branch then
          return vim.loop.cwd() .. "-" .. branch
        else
          return vim.loop.cwd()
        end
      end,
    },
  },
}
