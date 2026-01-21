return {
	{
		"vague-theme/vague.nvim",
		priority = 999,
		opts = {},
		config = function()
			-- NOTE: you do not need to call setup if you don't want to.
			vim.cmd("colorscheme vague")
		end
	},

}
