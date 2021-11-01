local M = {}

local plugin_loader = require "akyrey.plugin-loader"
local Log = require "akyrey.core.log"
local in_headless = #vim.api.nvim_list_uis() == 0

---Reset any startup cache files used by Packer and Impatient
---It also forces regenerating any template ftplugin files
---Tip: Useful for clearing any outdated settings
function M.reset_cache()
  _G.__luacache.clear_cache()

  plugin_loader:cache_reset()
  package.loaded["akyrey.lsp.templates"] = nil

  Log:debug "Re-generatring ftplugin template files"
  require("akyrey.lsp.templates").generate_templates()
end

return M
