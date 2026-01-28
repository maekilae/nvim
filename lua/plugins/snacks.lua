return {

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            picker = {},
            dashboard = {
                sections = {
                    { section = "header" },
                    {
                        pane = 2,
                        section = "terminal",
                        cmd = "/usr/local/bin/colorscript -e square",
                        height = 5,
                        padding = 1,
                    },
                    { section = "keys",  gap = 1, padding = 1 },
                    {
                        pane = 2,
                        icon = " ",
                        desc = "Browse Repo",
                        padding = 1,
                        key = "b",
                        action = function()
                            Snacks.gitbrowse()
                        end,
                    },
                    function()
                        local in_git = Snacks.git.get_root() ~= nil
                        local cmds = {
                            {
                                title = "Notifications",
                                cmd = "gh notify -s -a -n5",
                                action = function()
                                    vim.ui.open("https://github.com/notifications")
                                end,
                                key = "n",
                                icon = " ",
                                height = 5,
                                enabled = true,
                            },
                            {
                                title = "Open Issues",
                                cmd = "gh issue list -L 3",
                                key = "i",
                                action = function()
                                    vim.fn.jobstart("gh issue list --web",
                                        { detach = true })
                                end,
                                icon = " ",
                                height = 7,
                            },
                            {
                                icon = " ",
                                title = "Open PRs",
                                cmd = "gh pr list -L 3",
                                key = "P",
                                action = function()
                                    vim.fn.jobstart("gh pr list --web",
                                        { detach = true })
                                end,
                                height = 7,
                            },
                            {
                                icon = " ",
                                title = "Git Status",
                                cmd = "git --no-pager diff --stat -B -M -C",
                                height = 10,
                            },
                        }
                        return vim.tbl_map(function(cmd)
                            return vim.tbl_extend("force", {
                                pane = 2,
                                section = "terminal",
                                enabled = in_git,
                                padding = 1,
                                ttl = 5 * 60,
                                indent = 3,
                            }, cmd)
                        end, cmds)
                    end,
                    { section = "startup" },
                },
            },
        },
        keys = {
            { "<leader>/",  function() Snacks.picker.grep() end,                                    desc = "Grep" },
            -- find
            { "<leader>fb", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<leader>ff", function() Snacks.picker.files() end,                                   desc = "Find Files" },
            { "<leader>fg", function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
            { "<leader>fp", function() Snacks.picker.projects() end,                                desc = "Projects" },
            { "<leader>fr", function() Snacks.picker.recent() end,                                  desc = "Recent" },
            { "<leader>sd", function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
            { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
            -- git
            { "<leader>gb", function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
            { "<leader>gl", function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
            { "<leader>gL", function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
            { "<leader>gs", function() Snacks.picker.git_status() end,                              desc = "Git Status" },
            { "<leader>gS", function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
            { "<leader>gd", function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
            { "<leader>gf", function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
            -- LSP
            { "gd",         function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
            { "gD",         function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
            { "gr",         function() Snacks.picker.lsp_references() end,                          nowait = true,                  desc = "References" },
            { "gI",         function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
            { "gy",         function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
        },
    },
    }
