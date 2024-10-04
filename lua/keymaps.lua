vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local wk = require("which-key")
local builtin = require("telescope.builtin")
local neotest = require("neotest")

local testNearest = function()
	neotest.run.run {}
end

local testFile = function()
	neotest.run.run { vim.api.nvim_buf_get_name(0) }
end

local testOutput = function()
	neotest.output.open()
end

-- wk.register {
-- ["<leader>"] = {
-- 		["1"] = {
-- 			function()
-- 				vim.cmd(":ToggleTerm 1 name=foo")
-- 			end,
-- 			"Terminal 1",
-- 		},
-- 		["2"] = {
-- 			function()
-- 				vim.cmd(":ToggleTerm 2 name=bar")
-- 			end,
-- 			"Terminal 2",
-- 		},
--
-- 		["bd"] = { ":bd<cr>", "Delete buffer" },
-- 		d = {
-- 			name = "+Diagnostics",
-- 			n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Diagnostics next" },
-- 		},
-- E = { "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", "File browser" },
-- e = { "<cmd>NvimTreeFindFileToggle<cr>", "File tree" },
--
-- 		f = {
-- 			name = "+Find",
-- 		},
-- 		g = {
-- 			name = "+Git",
-- 			b = { builtin.git_branches, "Find git branches" },
-- 			s = { builtin.git_branches, "Find git stashes" },
-- 		},
-- 	},
-- 	t = {
-- 		name = "+Test",
-- 		t = {
-- 			function()
-- 				neotest.run.run {}
-- 			end,
-- 			"Run nearest test",
-- 		},
-- 		f = {
-- 			function()
-- 				neotest.run.run { vim.api.nvim_buf_get_name(0) }
-- 			end,
-- 			"Run tests in file",
-- 		},
-- 		o = {
-- 			function()
-- 				neotest.output.open()
-- 			end,
-- 			"Show test output",
-- 		},
-- 		p = {
-- 			function()
-- 				neotest.summary.toggle()
-- 			end,
-- 			"Show test summary",
-- 		},
-- 	},
-- 	g = {
-- 		name = "+Goto",
-- 		b = { builtin.git_branches, "Brances" },
-- 		d = { builtin.lsp_definitions, "Definitions" },
-- 		D = { builtin.lsp_type_definitions, "Type definitions" },
-- 		i = { builtin.lsp_implementations, "Implementations" },
-- 		r = { builtin.lsp_references, "References" },
-- },
-- }
--
wk.add {
	{ "<leader>]", ":bn<cr>" },
	{ "<leader>[", ":bp<cr>" },
	{ "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", mode = "n" },
	{ "<leader>lg", "<cmd>LazyGit<cr>", mode = "n" },
	{ "<leader>bd", ":bd<cr>" },
	{ "<leader>fs", builtin.current_buffer_fuzzy_find, name = "Find in current buffer" },
	{ "<leader>ff", builtin.find_files, name = "Find files" },
	{ "<leader>fg", builtin.live_grep, name = "Find by grep" },
	{ "<leader>fb", builtin.buffers, name = "Search in buffers" },
	{ "<leader>fh", builtin.help_tags, name = "Search in help" },
	{ "<leader>tt", testNearest },
	{ "<leader>tf", testFile },
	{ "<leader>to", testOutput },
}
