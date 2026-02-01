return {
    {
        'https://github.com/nvim-treesitter/nvim-treesitter',
        branch = "main",
        version = false,
        build = ':TSUpdate',
        lazy = false,
        languages = { 'c', 'lua', 'rust' },

        config = function(plugin)
            require('nvim-treesitter').install(plugin.languages)

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('treesitter.setup', {}),
                callback = function(args)
                    local buf = args.buf
                    local filetype = args.match

                    -- you need some mechanism to avoid running on buffers that do not
                    -- correspond to a language (like oil.nvim buffers), this implementation
                    -- checks if a parser exists for the current language
                    local language = vim.treesitter.language.get_lang(filetype) or filetype
                    if not vim.treesitter.language.add(language) then
                        return
                    end

                    -- replicate `fold = { enable = true }`
                    vim.wo.foldmethod = 'expr'
                    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

                    -- replicate `highlight = { enable = true }`
                    vim.treesitter.start(buf, language)

                    -- replicate `indent = { enable = true }`
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                    -- `incremental_selection = { enable = true }` cannot be easily replicated
                end,
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {},
        config = function()
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                },
                severity_sort = true,
            })
            vim.lsp.inlay_hint.enable(true)
        end
    },

    {
        "mason-org/mason-lspconfig.nvim",
        name = "mason-lspconfig",
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {
                    ensure_installed = {
                        "typescript-language-server",
                        "tailwindcss-language-server",
                        "eslint-lsp",
                    }
                }
            },
        },
        opts = {
            ensure_installed = { "lua_ls", "rust_analyzer", "gopls" },
        }
    },
    {
        'https://github.com/saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        enabled = true,
        build = 'cargo build --release',
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                -- follow latest release.
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- install jsregexp (optional!).
                build = "make install_jsregexp"
            }
        },

        opts = {
            keymap = { preset = 'enter' },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono',
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            fuzzy = { implementation = "rust" }
        },
    }
}
