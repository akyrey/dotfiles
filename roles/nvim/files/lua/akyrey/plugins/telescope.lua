local telescope = require'telescope'
local actions = require('telescope.actions')

local function init()
  telescope.setup {
    defaults = {
      file_sorter = require("telescope.sorters").get_fzy_sorter,
      prompt_prefix = ' >',
      color_devicons = true,

      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

      file_ignore_patterns = {
        "node_modules/.*",
        "documentation",
      },

      mappings = {
        i = {
          ["<C-q>"] = actions.send_to_qflist,
        },
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

local function search_dotfiles()
    require("telescope.builtin").find_files({
        prompt_title = "< VimRC >",
        cwd = vim.env.DOTFILES,
        hidden = true,
    })
end

return {
  init = init,
  search_dotfiles = search_dotfiles,
}
