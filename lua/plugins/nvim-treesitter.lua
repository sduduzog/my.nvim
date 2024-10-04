return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"JoosepAlviste/nvim-ts-context-commentstring",
		"nvim-treesitter/nvim-treesitter-context",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup {
			ensure_installed = {
				"eex",
				"elixir",
				"erlang",
				"heex",
				"html",
				"lua",
				"vim",
				"vimdoc",
				"markdown",
				"markdown_inline",
				"surface",
				"typescript",
			},
			context = {
				enable = true,
			},
			hightlight = {
				enable = true,
			},
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			autotag = {
				enable = true,
				filetypes = {
					"html",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
				},
			},
			rainbow = {
				enable = true,
				disable = { "html" },
				extended_mode = false,
				max_file_lines = nil,
			},

			additional_vim_regex_highlighting = false,
		}
	end,
}
