local f_ok, fidget = pcall(require, "fidget")
local n_ok, null_ls = pcall(require, "null-ls")
local m_ok, mason = pcall(require, "mason")
local m_n_ok, mason_null_ls = pcall(require, "mason-null-ls")
local m_d_ok, mason_dap = pcall(require, "mason-nvim-dap")
local ne_ok, neodev = pcall(require, "neodev")
local d_ok, dap = pcall(require, "dap")

if not f_ok or not n_ok or not m_ok or not m_n_ok or not m_d_ok or not ne_ok then
    return
end

neodev.setup()

mason.setup({
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        },
        keymaps = {
            toggle_package_expand = "<CR>",
            install_package = "i",
            update_package = "u",
            check_package_version = "c",
            update_all_packages = "U",
            check_outdated_packages = "C",
            uninstall_package = "X",
            cancel_installation = "<C-c>",
            apply_language_filter = "<C-f>",
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,

    github = {
        -- The template URL to use when downloading assets from GitHub.
        -- The placeholders are the following (in order):
        -- 1. The repository (e.g. "rust-lang/rust-analyzer")
        -- 2. The release version (e.g. "v0.3.0")
        -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
        download_url_template = "https://github.com/%s/releases/download/%s/%s",
    },
})

mason_null_ls.setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = true,
})

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.formatting.prettierd,
    }
})

mason_null_ls.setup_handlers({
    function(source_name, methods)
      -- all sources with no handler get passed here
      -- To keep the original functionality of `automatic_setup = true`,
      require("mason-null-ls.automatic_setup")(source_name, methods)
    end,
    -- stylua = function(source_name, methods)
    --   null_ls.register(null_ls.builtins.formatting.stylua)
    -- end,
})

mason_dap.setup({
    ensure_installed = {
        "chrome",
        "node2",
    },
    automatic_installation = true,
    automatic_setup = true,
})

mason_dap.setup_handlers({
    function(source_name)
        -- all sources with no handler get passed here
        -- Keep original functionality of `automatic_setup = true`
        require('mason-nvim-dap.automatic_setup')(source_name)
    end,
    chrome = function(source_name)
        dap.configurations.typescript = {
            {
                name = "Debug (Attach) - Remote",
                type = "chrome",
                request = "attach",
                program = "${file}",
                debugServer = 45635,
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222,
                webRoot = "${workspaceFolder}",
            }
        }
    end,
})

fidget.setup()
