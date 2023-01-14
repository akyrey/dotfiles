local packer = require("packer")

packer.init {
    git = { clone_timeout = 300 },
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

return packer.startup(function(use)
    -- Packer can manage itself
    use { "wbthomason/packer.nvim" }

    use { "lewis6991/impatient.nvim" }

    -- LSP Configuration & Plugins
    use {
        "neovim/nvim-lspconfig",
        requires = {
            -- Automatically install LSPs to stdpath for neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "jose-elias-alvarez/null-ls.nvim",
                requires = { "nvim-lua/plenary.nvim" },
            },
            "jayp0521/mason-null-ls.nvim",
            "jayp0521/mason-nvim-dap.nvim",

            -- Useful status updates for LSP
            "j-hui/fidget.nvim",

            -- Additional lua configuration, makes nvim stuff amazing
            "folke/neodev.nvim",
        },
    }
    use { "simrat39/rust-tools.nvim" }

    -- Auto completion and snippets
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "L3MON4D3/LuaSnip" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lua" },
            { "f3fora/cmp-spell" },
            { "hrsh7th/cmp-cmdline" },
            {
                "tzachar/cmp-tabnine",
                run = "./install.sh",
            },
            { "David-Kunz/cmp-npm" },
            { "davidsierradz/cmp-conventionalcommits" },
            { "ray-x/cmp-treesitter" },
        },
    }
    use {
        "rafamadriz/friendly-snippets",
        event = "InsertCharPre"
    }
    use {
        "L3MON4D3/LuaSnip",
        config = function()
            local utils = require("akyrey.utils")
            local paths = {}
            paths[#paths + 1] = utils.join_paths(vim.call("stdpath", "data"), "site", "pack", "packer", "start", "friendly-snippets")
            local user_snippets = utils.join_paths(vim.call("stdpath", "config"), "snippets")
            if utils.is_directory(user_snippets) then
                paths[#paths + 1] = user_snippets
            end
            require("luasnip.loaders.from_lua").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load {
                paths = paths,
            }
            require("luasnip.loaders.from_snipmate").lazy_load()
        end,
    }

    -- Catppuccin theme
    use {
        "catppuccin/nvim",
        as = "catppuccin",
    }
    use { "lukas-reineke/indent-blankline.nvim" }
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            { "kyazdani42/nvim-web-devicons" },
        },
    }
    use { "stevearc/dressing.nvim" }
    -- Color highlighter
    use { "norcalli/nvim-colorizer.lua" }

    use { "wakatime/vim-wakatime" }
    use {
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("akyrey.core.toggleterm").setup()
        end,
    }

    -- Whichkey
    use {
        "folke/which-key.nvim",
        event = "BufWinEnter",
        config = function()
            require("akyrey.core.which-key").setup()
        end,
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
        },
    }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use {
        "weilbith/nvim-code-action-menu",
        cmd = "CodeActionMenu",
    }

    -- Mark and easily navigate through files
    use { "ThePrimeagen/harpoon" }

    -- Parser generator and parsing library
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use {
        "p00f/nvim-ts-rainbow",
        after = "nvim-treesitter",
    }
    use {
        "windwp/nvim-ts-autotag",
        after = "nvim-treesitter",
    }
    use {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
    }
    use {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
    }
    use {
        "JoosepAlviste/nvim-ts-context-commentstring",
        after = "nvim-treesitter",
    }
    use {
        "nvim-treesitter/playground",
        after = "nvim-treesitter",
    }

    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
        }
    }

    -- Display undo history as a tree
    use { "mbbill/undotree" }

    -- Git related
    use { "tpope/vim-fugitive" }
    use { "lewis6991/gitsigns.nvim" }
    use {
        "sindrets/diffview.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
    }
    use { "ThePrimeagen/git-worktree.nvim" }

    -- Comment multiple lines
    use { "numToStr/Comment.nvim" }
    -- Highlight todos
    use {
        "folke/todo-comments.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
        },
    }

    -- Automatically insert pairs
    use { "windwp/nvim-autopairs" }
    -- Insert char surround targets
    use { "kylechui/nvim-surround" }

      -- Debugging
    use { "mfussenegger/nvim-dap" }
    use {
        "rcarriga/nvim-dap-ui",
        requires = {
            { "mfussenegger/nvim-dap" },
        },
    }
end)
