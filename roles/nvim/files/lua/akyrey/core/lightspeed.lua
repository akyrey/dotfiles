local M = {}

function M.config()
  akyrey.builtin.lightspeed = {
    active = true,
    on_config_done = nil,
    config = {
      ignore_case = false,
      exit_after_idle_msecs = { labeled = nil, unlabeled = 1000 },

      -- s/x
      jump_to_unique_chars = { safety_timeout = 400 },
      match_only_the_start_of_same_char_seqs = true,
      substitute_chars = { ['\r'] = '¬' },
      -- Leaving the appropriate list empty effectively disables
      -- "smart" mode, and forces auto-jump to be on or off.
      -- safe_labels = { ... },
      -- labels = { ... },

      -- f/t
      limit_ft_matches = 4,
      repeat_ft_with_target_char = false,
    },
  }
end

function M.setup()
  local status_ok, lightspeed = pcall(require, "lightspeed")
  if not status_ok then
    local Log = require "akyrey.core.log"
    Log:error "Failed to load lightspeed"
    return
  end

  lightspeed.setup(akyrey.builtin.lightspeed.config)

  if akyrey.builtin.lightspeed.on_config_done then
    akyrey.builtin.lightspeed.on_config_done(lightspeed)
  end
end

return M
