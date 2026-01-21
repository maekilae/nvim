return {
	{
		'https://github.com/nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			auto_install = true,
		},

		config = function()
			vim.lsp.enable({ "lua_ls", "gopls" })
			require'nvim-treesitter'.install { 'rust', 'javascript', 'zig' }
		end,
	},
	{
		"mason-org/mason.nvim",
		as = "mason",
		tag = "*",
		build = ":MasonUpdate",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			},
			ensure_installed = { "lua_ls", "rust_analyzer", "gopls" },
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		name = "mason-lspconfig",
		tag = "*",
		deps = {
			{
				"neovim/nvim-lspconfig",
				opts = {},
				config = function()
					vim.api.nvim_create_autocmd("LspAttach", {
						group = vim.api.nvim_create_augroup("lsp", { clear = true }),
						callback = function(args)
							-- 2
							vim.api.nvim_create_autocmd("BufWritePre", {
								-- 3
								buffer = args.buf,
								callback = function()
									-- 4 + 5
									vim.lsp.buf.format { async = false, id = args.data.client_id }
								end,
							})
						end
					})
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
		},
		opts = {
		}
	},
	{
		'https://github.com/saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		enabled = true,
		build = 'cargo build --release',
		tag = "*",
		deps = { { 'rafamadriz/friendly-snippets' } },

		---@module 'blink.cmp'
		---@type blink.cmp.Config
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

			fuzzy = { implementation = "lua" }
		},
	}
}
