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
				"emmet-language-server",
				"elixirls",
				"lua_ls",
				"volar",
				"stylua",
				"tailwindcss",
				"typescript-language-server",
			},
		}
	end,
}
