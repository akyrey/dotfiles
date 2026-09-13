return {
  -- Replaces the command line, messages and LSP progress with floating windows.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        -- intelephense emits this constantly on hover over untyped symbols.
        { filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
        -- "written" / "lines yanked" style noise.
        {
          filter = {
            event = "msg_show",
            any = { { find = "%d+L, %d+B" }, { find = "; after #%d+" }, { find = "; before #%d+" } },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice all" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss all" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice picker" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = { "i", "n", "s" } },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = { "i", "n", "s" } },
    },
  },

  -- Tab line. Runs in `tabs` mode, so it shows tabpages rather than buffers.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      options = {
        mode = "tabs",
        close_command = function(n)
          Snacks.bufdelete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          { filetype = "snacks_layout_box" },
        },
      },
    },
    keys = {
      { "[o", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev tab" },
      { "]o", "<cmd>BufferLineCycleNext<cr>", desc = "Next tab" },
      { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
    },
  },

  -- Status line.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    opts = function()
      local icons = { error = "E", warn = "W", info = "I", hint = "H" }
      return {
        options = {
          -- catppuccin ships flavour-suffixed theme names; "catppuccin-nvim"
          -- follows whichever flavour is configured rather than pinning one.
          theme = "catppuccin-nvim",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
          section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
          component_separators = { left = "\u{e0b5}", right = "\u{e0b7}" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            { "diagnostics", symbols = icons },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1 },
          },
          lualine_x = {
            -- Pending formatter / lsp / dap status.
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
            },
            { "diff" },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return os.date("%R")
            end,
          },
        },
        extensions = { "lazy", "fugitive", "quickfix", "man", "nvim-dap-ui", "overseer", "trouble" },
      }
    end,
  },

  -- Better quickfix window: preview, fuzzy filtering inside the list.
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = { winblend = 0 },
    },
  },

  -- Show the colour behind hex/rgb values.
  --
  -- This is catgoose's maintained fork of norcalli/nvim-colorizer.lua. The
  -- original has had no commits since 2024 and calls vim.tbl_flatten, which
  -- warns on every load under Neovim 0.13.
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        names = false, -- don't colour the word "red" in prose and code
        css = true,
        css_fn = true, -- rgb(), hsl()
        tailwind = true,
      },
    },
  },

  -- Colour-match nested brackets.
  {
    "hiphish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Key hint popup.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "ai" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>h", group = "harpoon" },
          { "<leader>o", group = "overseer" },
          { "<leader>r", group = "refactor" },
          { "<leader>s", group = "search" },
          { "<leader>t", group = "test" },
          { "<leader>u", group = "ui/toggle" },
          { "<leader>v", group = "vcs" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "<leader><tab>", group = "tabs" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps (which-key)",
      },
    },
  },

  -- Icons, used by bufferline, lualine, snacks and neo-tree-likes.
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
