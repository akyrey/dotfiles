local telescope = require'telescope'
local actions = require('telescope.actions')

local function init()
  telescope.setup {
    defaults = {
      prompt_prefix = ' >',
      color_devicons = true,

      file_ignore_patterns = {
        "node_modules",
        "documentation",
      },
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    }
  }

  telescope.load_extension('fzy_native')
  telescope.load_extension('git_worktree')
end

return {
  init = init,
}
