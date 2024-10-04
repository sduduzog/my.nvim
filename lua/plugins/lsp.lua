return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"nvim-lua/plenary.nvim",
		"L3MON4D3/LuaSnip",
		-- "VidocqH/lsp-lens.nvim",
		-- "ray-x/lsp_signature.nvim",
		-- 		"hrsh7th/cmp-buffer",
		-- 		"hrsh7th/cmp-cmdline",
		-- 		"hrsh7th/cmp-path",
		-- 		"petertriho/cmp-git",
		-- 		"onsails/lspkind.nvim",

		-- "L3MON4D3/LuaSnip",
		-- "hrsh7th/cmp-buffer",
		-- "hrsh7th/cmp-cmdline",
		-- "hrsh7th/cmp-path",
		-- "petertriho/cmp-git",
		-- "onsails/lspkind.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lsp_attach = function(client, bufnr)
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufnr,
				callback = function()
					require("nvim-lightbulb").update_lightbulb()
				end,
			})

			local wk = require("which-key")

			wk.add {
				{ "K", "<cmd>lua vim.lsp.buf.hover()<cr>" },
			}
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local lsp_options = {
			capabilities = capabilities,
			on_attach = on_attach,
			single_file_support = true,
		}

		local lsp = require("lspconfig")

		local mason_registry = require("mason-registry")
		local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
			.. "/node_modules/@vue/language-server"

		lsp.ts_ls.setup(vim.tbl_extend("force", lsp_options, {
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_language_server_path,
						languages = { "vue" },
					},
				},
			},
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentFormattingRangeProvider = false
			end,
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		}))

		lsp.tailwindcss.setup(vim.tbl_extend("force", lsp_options, {
			settings = {
				tailwindCSS = {
					includeLanguages = {
						elixir = "html-eex",
						eelixir = "html-eex",
						heex = "html-eex",
					},
					emmetCompletions = true,
					experimental = {
						classRegex = {
							'class[:]\\s*"([^"]*)"',
						},
					},
				},
			},
		}))

		lsp.elixirls.setup(vim.tbl_extend("force", lsp_options, {
			cmd = { "elixir-ls" },
			settings = { elixirLS = { dialyzerEnabled = false } },
		}))

		lsp.biome.setup(lsp_options)

		lsp.volar.setup(lsp_options)

		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert {
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete {},
				["<CR>"] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			},
		}
	end,
}
