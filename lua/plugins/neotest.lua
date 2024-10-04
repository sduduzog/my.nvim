return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
		"jfpedroza/neotest-elixir",
	},
	config = function()
		local neotest = require("neotest")
		-- require("neotest.logging"):set_level("trace")
		neotest.setup {
			adapters = {
				-- require("neotest-vitest"),
				require("neotest-jest") {
					jestCommand = "npx jest",
					cwd = require("neotest-jest").root,
					jest_test_discovery = false,
				},
				require("neotest-elixir") {
					extra_block_identifiers = { "test_with_mock" },
				},
			},
			discovery = {
				enabled = false,
			},
			summary = {
				mappings = {
					attach = "a",
					expand = "l",
					expand_all = "L",
					jumpto = "gf",
					output = "o",
					run = "<C-r>",
					short = "p",
					stop = "u",
				},
			},
			icons = {
				passed = " ",
				running = " ",
				failed = " ",
				unknown = " ",
				running_animated = vim.tbl_map(function(s)
					return s .. " "
				end, { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }),
			},
			diagnostic = {
				enabled = true,
			},
			output = {
				enabled = true,
				open_on_run = "short",
			},
			status = {
				enabled = true,
			},
		}

		-- local wk = require("which-key")
		--
		-- wk.add {
		-- 	{ "<leader>tt", testNearest },
		-- 	{ "<leader>tf", testFile },
		-- 	{ "<leader>to", testOutput },
		-- }
	end,
}
