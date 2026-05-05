return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      copilot_node_command = vim.fn.expand("$HOME") .. "/.asdf/installs/nodejs/24.14.0/bin/node", -- Node.js version must be > 18.x
    },
  },
  {
    "akyrey/condition-order.nvim",
    ft = { "php", "go" },
    opts = {},
  },
  {
    "akyrey/openapi-navigator.nvim",
    ft = { "yaml", "json" },
    opts = {
      laravel = {
        cmd = { "./xenv", "artisan", "route:list", "--json" },
      },
    },
  },
  },
}
