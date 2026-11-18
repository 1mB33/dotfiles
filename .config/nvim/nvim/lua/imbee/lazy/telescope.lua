return {
	"nvim-telescope/telescope.nvim",
	branch = "master", -- or keep version = "*" if you prefer tagged releases
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- optional, faster sorting (needs make):
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	cmd = "Telescope",
	keys = {
		{
			"<leader>pf",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Find files",
		},
		{
			"<C-p>",
			function()
				local builtin = require("telescope.builtin")
				if not pcall(builtin.git_files) then
					builtin.find_files()
				end
			end,
			desc = "Git files (fallback: all files)",
		},
		{
			"<leader>pws",
			function()
				require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
			end,
			desc = "Grep word",
		},
		{
			"<leader>pWs",
			function()
				require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>") })
			end,
			desc = "Grep WORD",
		},
		{
			"<leader>ps",
			function()
				require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
			end,
			desc = "Grep prompt",
		},
		{
			"<leader>pg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Live grep",
		},
		{
			"<leader>vh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Help tags",
		},
	},
	config = function()
		require("telescope").setup({})
		pcall(require("telescope").load_extension, "fzf")
	end,
}
