local ok, telescope = pcall(require, "telescope")
local _, builtin = pcall(require, "telescope.builtin")
local _, themes = pcall(require, "telescope.themes")
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

-- Custom finders
local find_config_files = function(opts)
  opts = opts or {}
  local theme_opts = themes.get_dropdown {
    sorting_strategy = "ascending",
    prompt = ">> ",
    prompt_title = "~ Config files ~",
    cwd = "~/.config/nvim",
    find_command = { "git", "ls-files" },
  }
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.find_files(opts)
end

local grep_config_files = function(opts)
  opts = opts or {}
  local theme_opts = themes.get_dropdown {
    sorting_strategy = "ascending",
    prompt = ">> ",
    prompt_title = "~ Search Config ~",
    cwd = "~/.config/nvim",
  }
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.live_grep(opts)
end

-- Keymaps
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find()
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sD", ":Telescope diagnostics bufnr=0 theme=get_ivy<cr>", { desc = "[S]earch Buffer [D]iagnostics" })
vim.keymap.set("n", "<leader>sc", function() find_config_files() end, { desc = "[S]earch [C]onfig" })
vim.keymap.set("n", "<leader>sC", function() grep_config_files() end, { desc = "Grep [C]onfig" })

vim.keymap.set("n", "<leader>sW", function() telescope.extensions.git_worktree.git_worktrees() end, { desc = "[S]earch [W]orktrees" })
vim.keymap.set("n", "<leader>wc", function() telescope.extensions.git_worktree.create_git_worktree() end, { desc = "[W]orktree [C]reate" })
vim.keymap.set("v", "<leader>rr", function() telescope.extensions.refactoring.refactors() end, { desc = "Open [R]efacto[r]ing Menu" })

vim.keymap.set("n", "<leader>ss", ":Telescope git_status<cr>", { desc = "[S]earch Git [S]tatus" })
vim.keymap.set("n", "<leader>sb", ":Telescope git_branches<cr>", { desc = "[S]earch [B]ranch" })
vim.keymap.set("n", "<leader>sv", ":Telescope git_commits<cr>", { desc = "[S]earch Commits" })
vim.keymap.set("n", "<leader>sV", ":Telescope git_bcommits<cr>", { desc = "[S]earch Commits for current file" })
vim.keymap.set("n", "<leader>sH", ":Telescope highlights<cr>", { desc = "[S]earch [H]ighlight gruops" })
vim.keymap.set("n", "<leader>sM", ":Telescope man_pages<cr>", { desc = "[S]earch [M]an Pages" })
vim.keymap.set("n", "<leader>sR", ":Telescope registers<cr>", { desc = "[S]earch [R]egisters" })
vim.keymap.set("n", "<leader>sk", ":Telescope keymaps<cr>", { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sC", ":Telescope commands<cr>", { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>sq", ":Telescope quickfix<cr>", { desc = "[S]earch [Q]uickfix list" })
vim.keymap.set("n", "<leader>st", ":TodoTelescope<cr>", { desc = "[S]earch [T]odo" })
