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
				"astro-language-server",
				"bashls",
				"beautysh",
				"emmet-ls",
				"eslint-lsp",
				"gopls",
				"lua_ls",
				"prettierd",
				"volar",
				"stylua",
				"tailwindcss",
				"typescript-language-server",
				"zls",
			},
		}
	end,
}
