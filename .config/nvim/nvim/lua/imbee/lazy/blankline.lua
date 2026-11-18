return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {
		indent = {
			char = "|",
			tab_char = "|",
			highlight = "Whitespace",
		},
		scope = {
			enabled = true,
			show_start = true,
			show_end = false,
		},
	},
	config = function(_, opts)
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2c313a" })
			vim.api.nvim_set_hl(0, "IblScope", { fg = "#98c379" })
		end)

		require("ibl").setup(opts)
	end,
}
