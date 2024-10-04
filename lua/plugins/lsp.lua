return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"nvim-lua/plenary.nvim",
		-- "VidocqH/lsp-lens.nvim",
		-- "ray-x/lsp_signature.nvim",
		-- 		"L3MON4D3/LuaSnip",
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
		require("mason").setup {}
		require("mason-tool-installer").setup {
			ensure_installed = {
				-- "biome",
				-- "emmet-language-server",
				-- "elixirls",
				-- "eslint",
				-- "lua_ls",
				"volar",
				-- "stylua",
				"tailwindcss",
				"typescript-language-server",
			},
		}

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

		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		local lsp = require("lspconfig")

		local mason_registry = require("mason-registry")
		local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
			.. "/node_modules/@vue/language-server"

		lsp.ts_ls.setup {
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
			-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		}

		lsp.biome.setup {}

		lsp.volar.setup {}

		lsp.tailwindcss.setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		lsp.tailwindcss.setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		local cmp = require("cmp")

		cmp.setup {
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},
			sources = {
				{ name = "nvim_lsp" },
			},
		}
	end,
}
