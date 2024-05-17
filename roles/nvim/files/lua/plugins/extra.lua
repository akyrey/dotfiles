return {
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
  {
    "mbbill/undotree",
    event = "VeryLazy",
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
    },
  },
  {
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>o", "<Cmd>OverseerToggle<CR>", desc = "Toggle overseer task runner" },
    },
    opts = {},
  },
  -- {
  --   dir = "~/personal/timecamp.nvim",
  --   opts = {},
  -- },
}
