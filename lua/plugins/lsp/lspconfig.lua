return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvimtools/none-ls.nvim",
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
			"VidocqH/lsp-lens.nvim",
			"ray-x/lsp_signature.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lsp = require("lspconfig")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			local on_attach = function(client, bufnr)
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

				local wk = require("which-key")

				wk.register({
					K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
					["<leader>"] = {
						a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code actions" },
						r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
					},
				}, { buffer = bufnr })

				require("lsp_signature").on_attach({
					bind = true,
				}, bufnr)
			end

			local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			-- lsp.elixirls.setup {
			-- 	cmd = { "elixir-ls" },
			-- 	on_attach = on_attach,
			-- 	capabilities = lsp_capabilities,
			-- }

			lsp.emmet_language_server.setup {
				on_attach = on_attach,
				capabilities = lsp_capabilities,
				filetypes = { "elixir", "eelixir", "heex" },
			}

			lsp.eslint.setup {
				on_init = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentFormattingRangeProvider = false
				end,
				on_attach = on_attach,
				capabilities = lsp_capabilities,
			}

			lsp.lua_ls.setup {
				on_init = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentFormattingRangeProvider = false
				end,
				on_attach = on_attach,
				capabilities = lsp_capabilities,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			}

			lsp.tailwindcss.setup {
				capabilities = lsp_capabilities,
				filetypes = { "html", "elixir", "eelixir", "heex" },
				init_options = {
					userLanguages = {
						elixir = "html-eex",
						eelixir = "html-eex",
						heex = "html-eex",
					},
				},
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								'class[:]\\s*"([^"]*)"',
							},
						},
					},
				},
			}

			lsp.tailwindcss.setup {
				init_options = {
					userLanguages = {
						elixir = "html-eex",
						eelixir = "html-eex",
						heex = "html-eex",
					},
				},
			}

			lsp.tsserver.setup {
				on_init = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentFormattingRangeProvider = false
				end,
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			}

			local null_ls = require("null-ls")

			null_ls.setup {
				on_attach = on_attach,
				capabilities = lsp_capabilities,
				update_on_insert = true,
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.code_actions.gitsigns.with {
						config = {
							filter_actions = function(title)
								return title:lower():match("blame") == nil
							end,
						},
					},
				},
			}

			require("lsp-lens").setup {}
		end,
	},
}
