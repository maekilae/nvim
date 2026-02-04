return {
	{
		"nvim-mini/mini.nvim",
		version = false,
		config = function()
			require("mini.icons").setup()
			require("mini.pairs").setup()
			require("mini.ai").setup()
			require("mini.surround").setup({
				mappings = {
					add = "gsa", -- Add surrounding in Normal and Visual modes
					delete = "gsd", -- Delete surrounding
					find = "gsf", -- Find surrounding (to the right)
					find_left = "gsF", -- Find surrounding (to the left)
					highlight = "gsh", -- Highlight surrounding
					replace = "gsr", -- Replace surrounding
					-- update_n_lines = "gsn", -- Update `n_lines`
				},
			})
			require("mini.comment").setup({
				options = {
					custom_commentstring = nil,
					ignore_blank_line = false,
					start_of_line = false,
					pad_comment_parts = true,
				},

				mappings = {
					comment = "gc",
					comment_line = "gcc",
					comment_visual = "gc",
					textobject = "gc",
				},
				hooks = {
					pre = function() end,
					post = function() end,
				},
			})
		end,
	},
}
