return {
	"elixir-tools/elixir-tools.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local elixir = require("elixir")
		local elixirls = require("elixir.elixirls")

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		elixir.setup {
			nextls = { enable = true },
			credo = {
				enable = true,
			},
			elixirls = {
				enable = true,
				settings = elixirls.settings {
					dialyzerEnabled = false,
					enableTestLenses = false,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format { async = false }
							end,
						})
					end

					vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
					vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
					vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
				end,
			},
		}
	end,
}
