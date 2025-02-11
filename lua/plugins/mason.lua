return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup {}
		require("mason-tool-installer").setup {
			ensure_installed = {
				"bashls",
				"beautysh",
				"biome",
				"elixirls",
				"emmet-language-server",
				"gopls",
				"lua_ls",
				"volar",
				"stylua",
				"tailwindcss",
				"typescript-language-server",
				"zls",
			},
		}
	end,
}
