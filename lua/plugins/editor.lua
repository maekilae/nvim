return {
	{
		"https://github.com/nvim-telescope/telescope.nvim",
		tag = "*", 
		deps = {
			{'https://github.com/nvim-lua/plenary.nvim'},
			{'https://github.com/nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
		},
		opts={

		},
		keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Telescope live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Telescope buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Telescope help tags" },
    },
	},
	{
  "https://github.com/mikavilpas/yazi.nvim",
  tag = "*", -- use the latest stable version
  --event = "VeryLazy",
  deps = {
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>n",
      "<cmd>Yazi<cr>",
      mode = { "n", "v" },
      desc = "Open yazi at the current file",
    },
    {
      -- Open in the current working directory
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  }
  },
}
