return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"nvim-lua/plenary.nvim",
		"L3MON4D3/LuaSnip",
		"onsails/lspkind-nvim",
		"roobert/tailwindcss-colorizer-cmp.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		---@diagnostic disable-next-line: unused-local
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
			on_attach = lsp_attach,
			single_file_support = true,
		}

		local lsp = require("lspconfig")

		lsp.lua_ls.setup(vim.tbl_extend("force", lsp_options, {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
						},
					},
				},
			},
		}))

		local mason_registry = require("mason-registry")
		-- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path()
		--     .. '/node_modules/@vue/language-server'

		lsp.ts_ls.setup(vim.tbl_extend("force", lsp_options, {
			init_options = {
				-- plugins = {
				--   {
				--     name = '@vue/typescript-plugin',
				--     location = vue_language_server_path,
				--     languages = { 'vue' },
				--   },
				-- },
			},
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		}))

		lsp.eslint.setup(lsp_options)

		lsp.tailwindcss.setup(vim.tbl_extend("force", lsp_options, {
			filetypes = {
				"html",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"heex",
				"eelixir",
				"elixir",
			},
			init_options = {
				userLanguages = {
					heex = "html",
					eelixir = "html",
					["html.heex"] = "html",
				},
			},
			settings = {
				tailwindCSS = {
					experimental = {
						emmetCompletions = true,
						classRegex = {
							'class[:]\\s*"([^"]*)"',
							'class: "([^"]*)"',
						},
						includeLanguages = {
							heex = "html-eex",
							elixir = "html-eex",
						},
					},
				},
			},
		}))

		-- lsp.tailwindcss.setup(vim.tbl_extend("force", lsp_options, {
		-- 	init_options = {
		-- 		userLanguages = {
		-- 			heex = "html-eex",
		-- 			elixir = "html-eex",
		-- 		},
		-- 	},
		-- 	settings = {
		-- 		tailwindCSS = {
		-- 			emmetCompletions = true,
		-- 			experimental = {
		-- 				classRegex = {
		-- 					'class[:]\\s*"([^"]*)"',
		-- 				},
		-- 			},
		-- 			includeLanguages = {
		-- 				heex = "html-eex",
		-- 				elixir = "html-eex",
		-- 			},
		-- 		},
		-- 	},
		-- }))

		-- lsp.emmet_ls.setup(vim.tbl_extend("force", lsp_options, {
		-- filetypes = {
		-- 	"css",
		-- 	"eruby",
		-- 	"html",
		-- 	"javascript",
		-- 	"javascriptreact",
		-- 	"less",
		-- 	"sass",
		-- 	"scss",
		-- 	"svelte",
		-- 	"pug",
		-- 	"typescriptreact",
		-- 	"vue",
		-- 	"heex",
		-- 	"elixir",
		-- },
		-- settings = {
		-- 	emmet = {
		-- 		includeLanguages = {
		-- 			["phoenix-heex"] = "html",
		-- 		},
		-- 	},
		-- },
		-- }))

		lsp.astro.setup(lsp_options)

		lsp.bashls.setup(lsp_options)

		lsp.gopls.setup(vim.tbl_extend("force", lsp_options, {
			settings = {
				gopls = {
					staticcheck = true,
					gofumpt = true,
				},
			},
		}))

		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup {
			preselect = "item",
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
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
				{ name = "buffer" },
			},
			formatting = {
				format = require("lspkind").cmp_format {
					mode = "symbol",
				},
			},
		}
	end,
}
