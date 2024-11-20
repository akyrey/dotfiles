return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })

      opts.presets.lsp_doc_border = true
    end,
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "[o", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
      { "]o", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    },
    opts = {
      options = {
        mode = "tabs",
      },
    },
  },
  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
  },
  {
    "kevinhwang91/nvim-bqf",
  },
  -- Color highlighter
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    opts = {
      "*", -- Highlight all files, but customize some others.
      css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
    },
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = "BufEnter",
  },
}
