return {
	{
		'https://github.com/nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			auto_install = true,
		},

		config = function()
			vim.lsp.enable({ "lua_ls", "gopls" })
			require 'nvim-treesitter'.install { 'rust', 'javascript', 'zig' }
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
			{ "mason-org/mason.nvim", opts = {} },
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
				nerd_font_variant = 'mono'
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
