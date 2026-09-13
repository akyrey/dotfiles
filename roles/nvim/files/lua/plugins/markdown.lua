return {
  -- In-buffer markdown rendering: headings, tables, code blocks, callouts.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    opts = {
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = {} },
      checkbox = { enabled = true },
    },
    -- stylua: ignore
    keys = {
      { "<leader>um", function() require("render-markdown").buf_toggle() end, desc = "Toggle markdown rendering" },
    },
  },

  -- Live preview in the browser.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown preview" },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
