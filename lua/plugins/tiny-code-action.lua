return {
	"rachartier/tiny-code-action.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
	},
	event = "LspAttach",
	config = function()
		require("tiny-code-action").setup()
		local wk = require("which-key")

		wk.add {
			{ "ga", require("tiny-code-action").code_action },
		}
	end,
}
