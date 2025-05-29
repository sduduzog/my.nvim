return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup {
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "beautysh" },
				vue = { "prettierd", "prettier" },
			},
			format_on_save = {
				timeout_ms = 10000,
				lsp_format = "fallback",
			},
		}
	end,
}
