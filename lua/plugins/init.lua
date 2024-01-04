local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
	{
		"folke/which-key.nvim",
		opts = {},
	},
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	{ "jiangmiao/auto-pairs" },
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
	},
	{ "nvim-tree/nvim-web-devicons" },
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				toggler = {
					line = "<leader>//",
					block = "<leader>/b",
				},
				opleader = {
					line = "//",
					block = "/b",
				},
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"<leader>gp",
					require("gitsigns").prev_hunk,
					{ buffer = bufnr, desc = "[G]o to [P]revious Hunk" }
				)
				vim.keymap.set(
					"n",
					"<leader>gn",
					require("gitsigns").next_hunk,
					{ buffer = bufnr, desc = "[G]o to [N]ext Hunk" }
				)
				vim.keymap.set(
					"n",
					"<leader>ph",
					require("gitsigns").preview_hunk,
					{ buffer = bufnr, desc = "[P]review [H]unk" }
				)
			end,
		},
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open lazygit" })
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			-- LSP support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			-- Extras
			{ "nvimtools/none-ls.nvim" },
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.diagnostics.eslint_d.with({
						condition = function(utils)
							return utils.root_has_file({ ".eslintrc", ".eslintrc.cjs" })
						end,
					}),
					null_ls.builtins.code_actions.eslint_d,
					null_ls.builtins.code_actions.gitsigns,
				},
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", "package.json", ".git"),
			})

			require("mason").setup({})

			local lsp_zero = require("lsp-zero")

			lsp_zero.on_attach(function(_, _)
				lsp_zero.buffer_autoformat()
			end)

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "volar" },
				handlers = {
					lsp_zero.default_setup,
				},
			})

			local lua_opts = lsp_zero.nvim_lua_ls({
				on_init = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentFormattingRangeProvider = false
				end,
			})
			require("lspconfig").lua_ls.setup(lua_opts)
			require("lspconfig").volar.setup({
				on_init = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentFormattingRangeProvider = false
				end,
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
				settings = {
					css = {
						lint = {
							unknownAtRules = "ignore",
						},
					},

					scss = {
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})

			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()
			local cmp_format = require("lsp-zero").cmp_format()
			cmp.setup({
				preselect = "item",
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp_action.luasnip_supertab(),
					["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
				}),
				formatting = cmp_format,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lspsaga").setup({})
			vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga diagnostic_jump_next<cr>")
			vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<cr>")
			vim.keymap.set("n", "gf", "<cmd>Lspsaga finder<cr>")
			vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<cr>")
			vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					packer = {},
					NvimTree = {},
					statusline = {},
					winbar = {},
				},
				extensions = {
					"toggleterm",
					"nvim-tree",
					"fzf",
				},
			},
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				sort_by = "case_sensitive",
				view = {
					float = {
						enable = true,
						open_win_config = function()
							local screen_w = vim.opt.columns:get()
							local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
							local window_w = screen_w * WIDTH_RATIO
							local window_h = screen_h * HEIGHT_RATIO
							local window_w_int = math.floor(window_w)
							local window_h_int = math.floor(window_h)
							local center_x = (screen_w - window_w) / 2
							local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
							return {
								border = "rounded",
								relative = "editor",
								row = center_y,
								col = center_x,
								width = window_w_int,
								height = window_h_int,
							}
						end,
					},
					width = function()
						return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
					end,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
					exclude = { ".env*" },
				},
			})

			vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle file tree" })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		config = function()
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>ss", builtin.current_buffer_fuzzy_find, {})

			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch in [F]iles" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch in [B]uffers" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch in [H]elp" })

			vim.keymap.set("n", "<leader>sd", builtin.lsp_definitions, { desc = "[S]earch in [D]efinitions" })
			vim.keymap.set("n", "<leader>si", builtin.lsp_implementations, { desc = "[S]earch for [I]mplimentations" })

			vim.keymap.set("n", "<C-d>", builtin.diagnostics, { desc = "Diagnostics" })
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<leader>;]],
				direction = "float",
				start_in_insert = true,
				persist_size = true,
				close_on_exit = true,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
				winbar = {
					enabled = false,
					name_formatter = function(term) --  term: Terminal
						return term.name
					end,
				},
			})
		end,
	},
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
				"NormalFloat",
				extra_groups = {
					"NvimTreeNormal",
					"ToggleTerm",
				},
			})
			vim.keymap.set("n", "<S-F6>", ":TransparentToggle<CR>")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"css",
					"diff",
					"elixir",
					"go",
					"graphql",
					"html",
					"javascript",
					"json",
					"lua",
					"make",
					"markdown",
					"markdown_inline",
					"scss",
					"sql",
					"typescript",
					"vim",
					"vue",
				},
				hightlight = {
					enable = true,
				},
				highlight = {
					enable = true,
				},
				indent = { enable = true },
				autotag = {
					enable = true,
					filetypes = {
						"html",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
					},
				},
				rainbow = {
					enable = true,
					disable = { "html" },
					extended_mode = false,
					max_file_lines = nil,
				},

				additional_vim_regex_highlighting = false,
			})
		end,
	},
	{
		"klen/nvim-test",
		config = function()
			require("nvim-test").setup({
				term = "toggleterm",
			})

			require("nvim-test.runners.jest"):setup({
				args = { "--collectCoverage=false" },
			})

			vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", { desc = "Run nearest test" })
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-jest",
			"mfussenegger/nvim-dap",
			"okuuva/auto-save.nvim",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-jest")({
						jestConfigFile = "jest.config.js",
						env = { CI = true },
					}),
					-- require("neotest-vim-test")({
					--     ignore_file_types = { "python", "vim", "lua" },
					-- }),
				},
				quickfix = {
					enabled = false,
					open = false,
				},
				output_panel = {
					open = "rightbelow vsplit | resize 30",
				},
				status = {
					virtual_text = false,
					signs = true,
				},
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
	},
}
