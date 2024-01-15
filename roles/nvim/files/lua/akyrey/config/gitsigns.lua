local M = {}

M.setup = function()
    local ok, gitsigns = pcall(require, "gitsigns")

    if not ok then
        return
    end

    gitsigns.setup({
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "󰐊" },
            topdelete = { text = "󰐊" },
            changedelete = { text = "▎" },
            untracked = { text = "┆" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
            interval = 1000,
            follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
            -- Options passed to nvim_open_win
            border = 'single',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },
        yadm = {
            enable = false
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
            end, { expr = true, desc = "Next hunk" })

            map("n", "[c", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
            end, { expr = true, desc = "Previous hunk" })

            -- Actions
            map({ "n", "v" }, "<leader>vs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage current hunk" })
            map({ "n", "v" }, "<leader>vr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset current hunk" })
            map('n', '<leader>vS', gs.stage_buffer, { desc = "Stage current buffer" })
            map("n", "<leader>vu", gs.undo_stage_hunk, { desc = "Unstage current hunk" })
            map("n", "<leader>vR", gs.reset_buffer, { desc = "Reset current buffer" })
            map("n", "<leader>vp", gs.preview_hunk, { desc = "Preview hunk" })
            map("n", "<leader>vb", function() gs.blame_line { full = true } end, { desc = "Git blame" })
            map("n", "<leader>vd", gs.diffthis, { desc = "Show hunk diff" })
            map("n", "<leader>vD", function() gs.diffthis("~") end, { desc = "Show buffer diff" })
            map("n", "<leader>vd", gs.toggle_deleted, { desc = "Toggle deleted hunks" })

            -- Text objects
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk()<CR>", { desc = "Select hunk" })
        end
    })
end

return M
