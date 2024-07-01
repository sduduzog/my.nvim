return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-media-files.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function()
		local telescope = require("telescope")
		local fb_actions = telescope.extensions.file_browser.actions
		telescope.setup {
			extensions = {
				file_browser = {
					mappings = {
						["i"] = {
							["<C-c>"] = fb_actions.create,
							["<C-d>"] = fb_actions.remove,
						},
					},
				},
			},
		}
		telescope.load_extension("file_browser")
		telescope.load_extension("media_files")
	end,
}
