-- Debugging
return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("akyrey.config.dap").setup()
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        config = function()
            require("akyrey.config.dap").setup_ui()
        end,
    },
}
