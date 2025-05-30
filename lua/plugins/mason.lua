return {
	"williamboman/mason.nvim",
	tag = "v2.0.0",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup {}
		require("mason-tool-installer").setup {
			ensure_installed = {
				"astro-language-server",
				"bashls",
				"beautysh",
				"emmet-ls",
				"eslint-lsp",
				"gopls",
				"lua_ls",
				"prettierd",
				"vue-language-server",
				"stylua",
				"tailwindcss",
				"typescript-language-server",
			},
		}
	end,
}
