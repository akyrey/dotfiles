-- snacks.nvim is the substrate for the picker, explorer, notifications and a
-- pile of small QoL modules. It loads at startup because other specs call
-- `Snacks.*` and because bigfile/quickfile have to run before the first buffer.
local root = function()
  return require("core.root").get()
end

return {
  "folke/snacks.nvim",
  priority = 900,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true }, -- disable expensive features on huge files
    quickfile = { enabled = true }, -- render the file before loading plugins
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true }, -- LSP reference navigation with ]] / [[
    -- Deliberately off: the dashboard gets in the way of opening a file
    -- directly, and smooth scrolling fights the centred-cursor keymaps.
    dashboard = { enabled = false },
    scroll = { enabled = false },

    explorer = { replace_netrw = true },
    picker = {
      ui_select = true, -- route vim.ui.select through the picker
      sources = {
        ---@class snacks.picker.explorer.Config
        explorer = {
          auto_close = true,
          matcher = { sort_empty = false, fuzzy = true },
          layout = {
            preset = "telescope",
            border = true,
            reverse = false,
            preview = false,
          },
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    -- Top level
    { "<leader><space>", function() Snacks.picker.files({ cwd = root() }) end, desc = "Find files (root dir)" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep({ cwd = root() }) end, desc = "Grep (root dir)" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "<leader>e", function() Snacks.explorer({ cwd = root() }) end, desc = "Explorer (root dir)" },
    { "<leader>E", function() Snacks.explorer() end, desc = "Explorer (cwd)" },

    -- Find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find config file" },
    { "<leader>ff", function() Snacks.picker.files({ cwd = root() }) end, desc = "Find files (root dir)" },
    { "<leader>fF", function() Snacks.picker.files() end, desc = "Find files (cwd)" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find files (git-files)" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent (cwd)" },
    { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
    { "<leader>fn", function() Snacks.scratch() end, desc = "New scratch buffer" },
    { "<leader>fe", function() Snacks.explorer({ cwd = root() }) end, desc = "Explorer (root dir)" },
    { "<leader>fE", function() Snacks.explorer() end, desc = "Explorer (cwd)" },

    -- Search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search history" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocommands" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command history" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
    { "<leader>sg", function() Snacks.picker.grep({ cwd = root() }) end, desc = "Grep (root dir)" },
    { "<leader>sG", function() Snacks.picker.grep() end, desc = "Grep (cwd)" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlight groups" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumplist" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Key maps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location list" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man pages" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>sw", function() Snacks.picker.grep_word({ cwd = root() }) end, desc = "Word (root dir)", mode = { "n", "x" } },
    { "<leader>sW", function() Snacks.picker.grep_word() end, desc = "Word (cwd)", mode = { "n", "x" } },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorscheme with preview" },

    -- Git
    { "<leader>gg", function() Snacks.lazygit({ cwd = root() }) end, desc = "Lazygit (root dir)" },
    { "<leader>gG", function() Snacks.lazygit() end, desc = "Lazygit (cwd)" },
    { "<leader>gb", function() Snacks.picker.git_log_line() end, desc = "Git blame line" },
    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git commits" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git diff (hunks)" },
    { "<leader>gl", function() Snacks.picker.git_log({ cwd = root() }) end, desc = "Git log (root dir)" },
    { "<leader>gL", function() Snacks.picker.git_log() end, desc = "Git log (cwd)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git current file history" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git stash" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse (open)", mode = { "n", "x" } },

    -- Buffers
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },

    -- Terminal
    { "<leader>ft", function() Snacks.terminal(nil, { cwd = root() }) end, desc = "Terminal (root dir)" },
    { "<leader>fT", function() Snacks.terminal() end, desc = "Terminal (cwd)" },
    { "<c-/>", function() Snacks.terminal(nil, { cwd = root() }) end, desc = "Terminal (root dir)", mode = { "n", "t" } },

    -- Misc
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle scratch buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select scratch buffer" },
    { "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler scratch buffer" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss all notifications" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Route vim.notify through snacks, and expose the debug helpers.
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        vim.print = _G.dd

        -- Toggles, all under <leader>u to match the rest of the config.
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle({
          name = "Auto Format (buffer)",
          get = function()
            return require("core.format").enabled()
          end,
          set = function()
            require("core.format").toggle()
          end,
        }):map("<leader>uf")
        Snacks.toggle({
          name = "Auto Format (global)",
          get = function()
            return vim.g.autoformat
          end,
          set = function()
            require("core.format").toggle({ global = true })
          end,
        }):map("<leader>uF")
      end,
    })
  end,
}
