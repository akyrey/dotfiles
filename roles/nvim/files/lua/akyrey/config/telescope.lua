local M = {}

M.setup = function()
    local ok, telescope = pcall(require, "telescope")
    local _, previewers = pcall(require, "telescope.previewers")
    local _, sorters = pcall(require, "telescope.sorters")
    local _, actions = pcall(require, "telescope.actions")

    if not ok then
        return
    end

    telescope.setup({
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "horizontal",
            layout_config = {
                width = 0.75,
                prompt_position = "bottom",
                preview_cutoff = 120,
                horizontal = { mirror = false },
                vertical = { mirror = false },
            },
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
            },
            file_ignore_patterns = {
                "node_modules/.*",
                "documentation",
            },
            path_display = { shorten = 5 },
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
            pickers = {
                find_files = {
                    find_command = { "fd", "--type=file", "--hidden", "--smart-case" },
                },
                live_grep = {
                    --@usage don't include the filename in the search results
                    only_sort_text = true,
                },
            },
            mappings = {
                i = {
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-c>"] = actions.close,
                    ["<C-j>"] = actions.cycle_history_next,
                    ["<C-k>"] = actions.cycle_history_prev,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<CR>"] = actions.select_default + actions.center,
                },
                n = {
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                },
            },
            file_previewer = previewers.vim_buffer_cat.new,
            grep_previewer = previewers.vim_buffer_vimgrep.new,
            qflist_previewer = previewers.vim_buffer_qflist.new,
            file_sorter = sorters.get_fuzzy_file,
            generic_sorter = sorters.get_generic_fuzzy_sorter,
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            },
        },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("refactoring")
    telescope.load_extension("git_worktree")
end

-- Custom finders
M.find_config_files = function(opts)
    opts = opts or {}
    local theme_opts = require("telescope.themes").get_dropdown {
        sorting_strategy = "ascending",
        prompt = ">> ",
        prompt_title = "~ Config files ~",
        cwd = "~/.config/nvim",
        find_command = { "git", "ls-files" },
    }
    opts = vim.tbl_deep_extend("force", theme_opts, opts)
    require("telescope.builtin").find_files(opts)
end

M.grep_config_files = function(opts)
    opts = opts or {}
    local theme_opts = require("telescope.themes").get_dropdown {
        sorting_strategy = "ascending",
        prompt = ">> ",
        prompt_title = "~ Search Config ~",
        cwd = "~/.config/nvim",
    }
    opts = vim.tbl_deep_extend("force", theme_opts, opts)
    require("telescope.builtin").live_grep(opts)
end

return M
