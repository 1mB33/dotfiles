return {
	"danymat/neogen",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	version = "*",
	keys = {
		{
			"<leader>nf",
			function()
				require("neogen").generate({ type = "func" })
			end,
			desc = "Neogen: function doc",
		},
		{
			"<leader>nt",
			function()
				require("neogen").generate({ type = "type" })
			end,
			desc = "Neogen: type doc",
		},
		{
			"<leader>nc",
			function()
				require("neogen").generate({ type = "class" })
			end,
			desc = "Neogen: class doc",
		},
	},
	opts = {
		snippet_engine = "nvim",
	},
}
