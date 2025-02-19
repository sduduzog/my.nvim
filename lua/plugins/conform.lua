return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", "biome", stop_after_first = true },
				typescript = { "prettierd", "prettier", "biome", stop_after_first = true },
				sh = { "beautysh" },
			},
			format_on_save = {
				timeout_ms = 10000,
				lsp_format = "fallback",
			},
		}
	end,
}
