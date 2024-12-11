return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = require("lazyvim.util").root(),
            reveal = true,
          })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = vim.loop.cwd(),
            reveal = true,
          })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({
            source = "git_status",
            toggle = true,
            reveal = true,
          })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({
            source = "buffers",
            toggle = true,
            reveal = true,
          })
        end,
        desc = "Buffer explorer",
      },
    },
    opts = {
      close_if_last_window = true,
      window = {
        position = "float",
        width = nil,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    keys = {
      { mode = "i", "<C-n>", false },
      { mode = "i", "<C-p>", false },
      { mode = "i", "<C-b>", false },
      { mode = "i", "<C-f>", false },
      { mode = "i", "<CR>", false },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.window = {
        documentation = {
          -- stylua: ignore
          border = {
         "╭", "─", "╮", "│", "╯", "─", "╰", "│"
          },
        },
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
      })
    end,
  },
}
