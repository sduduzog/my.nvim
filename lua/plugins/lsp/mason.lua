return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup {}
			require("mason-tool-installer").setup {
				ensure_installed = {
					"emmet-language-server",
					"eslint",
					-- "elixirls",
					"lua_ls",
					"stylua",
					"tailwindcss",
					"tsserver",
				},
			}
		end,
	},
}
