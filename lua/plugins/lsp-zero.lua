return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v4.x",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-path",
		"petertriho/cmp-git",
		"onsails/lspkind.nvim",
	},
	config = function()
		local lsp_zero = require("lsp-zero")
		local lsp_attach = function(client, bufnr)
			local opts = { buffer = bufnr }

			vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
			vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
			vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		end

		lsp_zero.format_on_save {
			format_opts = {
				async = false,
				timeout_ms = 10000,
			},
			server = {
				["lua_ls"] = { "lua" },
			},
		}

		lsp_zero.extend_lspconfig {
			sign_text = true,
			lsp_attach = lsp_attach,
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		}

		local lsp = require("lspconfig")

		lsp.lua_ls.setup {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentFormattingRangeProvider = false
			end,
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

		lsp.elixirls.setup {
			cmd = { "elixir-ls" },
		}

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
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		}

		lsp.volar.setup {}

		lsp.emmet_language_server.setup {
			filetypes = { "elixir", "eelixir", "heex" },
		}

		lsp.eslint.setup {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentFormattingRangeProvider = false
			end,
		}

		lsp.tailwindcss.setup {
			filetypes = { "html", "elixir", "eelixir", "heex", "vue" },
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

		local cmp_action = require("lsp-zero").cmp_action()

		local cmp = require("cmp")

		cmp.setup {
			preselect = "item",
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
			mapping = cmp.mapping.preset.insert {
				["<tab>"] = cmp_action.luasnip_supertab(),
				["<s-tab>"] = cmp_action.luasnip_shift_supertab(),
				-- ["<tab>"] = cmp_action.tab_complete(),
				-- ["<s-tab>"] = cmp.mapping.select_prev_item { bahavior = "select" },
				["<cr>"] = cmp.mapping.confirm(),
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			formatting = {
				fields = { "abbr", "kind", "menu" },
				format = require("lspkind").cmp_format {
					mode = "symbol_text",
					maxwidth = 80,
					ellipsis_char = "...",
				},
			},
		}
	end,
}
