return {
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            view_options = {
                show_hidden = true,
            },
        },
        -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        keys = {
            { "<leader>n", "<cmd>Oil<CR>", desc = "Toggle Oil" },
        },
        lazy = false,
    },
    {
        'folke/which-key.nvim',
        opts = {
            spec = {
                mode = { "n", "x" },
                { "<leader>c",  group = "code" },
                { "<leader>d",  group = "debug" },
                { "<leader>dp", group = "profiler" },
                { "<leader>f",  group = "file/find" },
                { "<leader>s",  group = "search" },
                { "[",          group = "prev" },
                { "]",          group = "next" },
                { "g",          group = "goto" },
                { "gs",         group = "surround" },
                { "gc",         group = "comment" },
                { "z",          group = "fold" },
            }
        },
    },

}
