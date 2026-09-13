return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "V13Axel/neotest-pest",
      "olimorris/neotest-phpunit",
      "fredrikaverpil/neotest-golang",
    },
    -- stylua: ignore
    keys = {
      { "<leader>t", "", desc = "+test" },
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all test files" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run nearest" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
      { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to test" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle watch" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest" },
    },
    opts = function()
      return {
        log_level = vim.log.levels.WARN,
        adapters = {
          -- Pest runs inside the docker environment, driven by ./xenv.
          require("neotest-pest")({
            sail_enabled = true,
            sail_project_path = "/skp",
            pest_cmd = { "./xenv", "php", "vendor/bin/pest" },
          }),
          require("neotest-phpunit"),
          require("neotest-golang"),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
      }
    end,
  },
}
