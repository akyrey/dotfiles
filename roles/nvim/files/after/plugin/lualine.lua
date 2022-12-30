local ok, lualine = pcall(require, "lualine")

if not ok then
    return
end

local window_width_limit = 80
local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    purple = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand "%:t") ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > window_width_limit
    end,
}

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end


local components = {
    mode = {
        function()
            return " "
        end,
        padding = { left = 0, right = 0 },
        color = {},
        cond = nil,
    },
    branch = {
        "b:gitsigns_head",
        icon = " ",
        color = { gui = "bold" },
        cond = conditions.hide_in_width,
    },
    filename = {
        "filename",
        color = {},
        cond = nil,
        path = 1,
    },
    diff = {
        "diff",
        source = diff_source,
        symbols = { added = "  ", modified = "柳", removed = " " },
        diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
        },
        color = {},
        cond = nil,
    },
    diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
        color = {},
        cond = conditions.hide_in_width,
    },
    treesitter = {
        function()
            local b = vim.api.nvim_get_current_buf()
            if next(vim.treesitter.highlighter.active[b]) then
                return "  "
            end
            return ""
        end,
        color = { fg = colors.green },
        cond = conditions.hide_in_width,
    },
    lsp = {
        function(msg)
            msg = msg or "LS Inactive"
            local buf_clients = vim.lsp.buf_get_clients()
            if next(buf_clients) == nil then
                -- TODO: clean up this if statement
                if type(msg) == "boolean" or #msg == 0 then
                    return "LS Inactive"
                end
                return msg
            end
            local buf_ft = vim.bo.filetype
            local buf_client_names = {}

            -- add client
            for _, client in pairs(buf_clients) do
                if client.name ~= "null-ls" then
                    table.insert(buf_client_names, client.name)
                end
            end

            -- TODO: add these
            -- add formatter
            --local formatters = require "akyrey.lsp.null-ls.formatters"
            --local supported_formatters = formatters.list_registered_providers(buf_ft)
            --vim.list_extend(buf_client_names, supported_formatters)

            -- add linter
            --local linters = require "akyrey.lsp.null-ls.linters"
            --local supported_linters = linters.list_registered_providers(buf_ft)
            --vim.list_extend(buf_client_names, supported_linters)

            return table.concat(buf_client_names, ", ")
        end,
        icon = " ",
        color = { gui = "bold" },
        cond = conditions.hide_in_width,
    },
    location = { "location", cond = conditions.hide_in_width, color = {} },
    progress = { "progress", cond = conditions.hide_in_width, color = {} },
    spaces = {
        function()
            if not vim.api.nvim_buf_get_option(0, "expandtab") then
                return "Tab size: " .. vim.api.nvim_buf_get_option(0, "tabstop") .. " "
            end
            local size = vim.api.nvim_buf_get_option(0, "shiftwidth")
            if size == 0 then
                size = vim.api.nvim_buf_get_option(0, "tabstop")
            end
            return "Spaces: " .. size .. " "
        end,
        cond = conditions.hide_in_width,
        color = {},
    },
    encoding = {
        "o:encoding",
        fmt = string.upper,
        color = {},
        cond = conditions.hide_in_width,
    },
    filetype = { "filetype", cond = conditions.hide_in_width, color = {} },
    scrollbar = {
        function()
            local current_line = vim.fn.line "."
            local total_lines = vim.fn.line "$"
            local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
        end,
        padding = { left = 0, right = 0 },
        color = { fg = colors.yellow, bg = colors.bg },
cond = nil,
},
}

lualine.setup({
    options = {
        theme = "catppuccin",
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            components.branch,
            components.filetype,
        },
        lualine_c = {
            components.diff,
        },
        lualine_x = {
            components.diagnostics,
            components.treesitter,
            components.lsp,
            components.filetype,
        },
        lualine_y = {},
        lualine_z = {
            components.scrollbar,
        },
    },
    extensions = {
        "fugitive",
        "nvim-dap-ui",
        "quickfix",
        "toggleterm",
    },
})
