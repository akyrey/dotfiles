return {
  -- :G / :Git, plus the three-way merge workflow that <leader>vb and <leader>vn
  -- in core/keymaps.lua drive.
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gedit" },
    keys = {
      { "<leader>vG", "<cmd>Git<cr>", desc = "Fugitive" },
    },
  },

  -- Side-by-side diffs and file history.
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    opts = {},
    keys = {
      { "<leader>vh", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
      { "<leader>vd", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
      { "<leader>vc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
    },
  },

  -- Gutter signs, hunk navigation, inline blame.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        ignore_whitespace = true,
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev hunk")

        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
        map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle line blame")
      end,
    },
  },
}
