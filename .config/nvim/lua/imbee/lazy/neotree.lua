return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = false, -- neo-tree lazy-loads itself; this is the setting its README recommends
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>pv", "<cmd>Neotree float reveal<CR>", desc = "File tree (float)" },
	},
	opts = {
		close_if_last_window = true,
		filesystem = {
			hijack_netrw_behavior = "open_current", -- use "disabled" to keep netrw
			follow_current_file = { enabled = true },
		},
	},
}
