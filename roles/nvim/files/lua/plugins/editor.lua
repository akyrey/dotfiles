return {
  -- Jump anywhere on screen with two characters.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle flash search" },
      -- Stands in for nvim-treesitter's incremental selection, which the main
      -- branch dropped: grow the selection with <c-space>, shrink with <BS>.
      {
        "<c-space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = { ["<c-space>"] = "next", ["<BS>"] = "prev" },
          })
        end,
        desc = "Treesitter incremental selection",
      },
    },
  },

  -- Pretty list for diagnostics, quickfix, LSP results and todos.
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = { win = { position = "right" } },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
    },
  },

  -- Highlight and search TODO/FIXME/HACK comments.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter={tag={TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },

  -- Project-wide search and replace with a live preview buffer.
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and replace",
      },
    },
  },

  -- Per-project, per-branch file bookmarks on <C-h/j/k/l>.
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      -- harpoon calls `key` on every list() access, i.e. on every <C-h/j/k/l>.
      -- Cache the branch per cwd instead of running git each time, and forget
      -- it whenever the branch may have changed: after changing directory,
      -- when focus returns from another tmux pane, or when leaving a terminal
      -- (lazygit, a shell) inside nvim.
      local branch_by_cwd = {} ---@type table<string, string|false>
      vim.api.nvim_create_autocmd({ "DirChanged", "FocusGained", "TermLeave" }, {
        group = vim.api.nvim_create_augroup("akyrey_harpoon_branch", { clear = true }),
        callback = function()
          branch_by_cwd = {}
        end,
      })

      ---@param cwd string
      ---@return string|false
      local function branch(cwd)
        if branch_by_cwd[cwd] == nil then
          local result = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { cwd = cwd, text = true }):wait()
          branch_by_cwd[cwd] = result.code == 0 and vim.trim(result.stdout) or false
        end
        return branch_by_cwd[cwd]
      end

      return {
        ---@type HarpoonSettings
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          -- Key the list by "<cwd>-<branch>" so each branch keeps its own set
          -- of files. Falls back to cwd alone outside a git repo.
          key = function()
            local cwd = vim.uv.cwd()
            local name = branch(cwd)
            return name and (cwd .. "-" .. name) or cwd
          end,
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
      { "<leader>ht", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon quick menu" },
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file #1" },
      { "<C-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file #2" },
      { "<C-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file #3" },
      { "<C-l>", function() require("harpoon"):list():select(4) end, desc = "Harpoon file #4" },
    },
  },

  -- Visualise the undo tree.
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow" },
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
    },
  },

  -- Run and watch shell tasks from nvim. Project commands come from projector
  -- (lua/util/projector.lua); the npm, make, ... providers stay for the rest.
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerTaskAction", "OverseerQuickAction" },
    opts = {
      -- composer scripts would run on the host, outside the project's
      -- container; projector's `composer` command runs them in the right place.
      disable_template_modules = { "overseer.template.composer" },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      overseer.register_template(require("util.projector").overseer_provider)
    end,
    keys = {
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
      {
        "<leader>oa",
        function()
          require("util.projector").run_with_args()
        end,
        desc = "Run projector command with args",
      },
      { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Task list" },
      { "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick action" },
    },
  },

  -- Extract function/variable, inline, debug prints.
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>r", "", desc = "+refactor", mode = { "n", "v" } },
      { "<leader>rs", function() require("refactoring").select_refactor() end, mode = "v", desc = "Select refactor" },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, mode = { "n", "v" }, desc = "Inline variable" },
      { "<leader>rf", function() require("refactoring").refactor("Extract Function") end, mode = "v", desc = "Extract function" },
      { "<leader>rF", function() require("refactoring").refactor("Extract Function To File") end, mode = "v", desc = "Extract function to file" },
      { "<leader>rx", function() require("refactoring").refactor("Extract Variable") end, mode = "v", desc = "Extract variable" },
      { "<leader>rp", function() require("refactoring").debug.print_var({ normal = true }) end, mode = "v", desc = "Debug print variable" },
      { "<leader>rP", function() require("refactoring").debug.printf({ below = false }) end, desc = "Debug print location" },
      { "<leader>rc", function() require("refactoring").debug.cleanup({}) end, desc = "Debug cleanup" },
    },
  },

  -- Inline highlighting for shorthand patterns. Hex and rgb() colours are left
  -- to nvim-colorizer (see plugins/ui.lua) rather than being done twice.
  {
    "nvim-mini/mini.hipatterns",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        highlighters = {
          -- 3-digit #rgb shorthand, expanded to #rrggbb for the highlight
          shorthand = {
            pattern = "()#%x%x%x()%f[^%x%w]",
            group = function(_, _, data)
              local match = data.full_match
              local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
              return MiniHipatterns.compute_hex_color_group("#" .. r .. r .. g .. g .. b .. b, "bg")
            end,
            extmark_opts = { priority = 2000 },
          },
        },
      }
    end,
  },
}
