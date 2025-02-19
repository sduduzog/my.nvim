local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local opt = vim.opt

vim.cmd([[
    filetype plugin indent on
    syntax on
]])

opt.updatetime = 250
-- line number
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.swapfile = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- hightligth active line
opt.cursorline = true

-- true color terminal settings
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes" -- enable specific highlights in debug mode

-- backspace settings
opt.backspace = "indent,eol,start"
-- enable native clipboard instead of vim default clipboard behavior
-- opt.clipboard:append "unnamedplus"
vim.opt.clipboard:prepend { "unnamed", "unnamedplus" }

-- split windows
opt.splitright = true
opt.splitbelow = true

-- set dash as normal letter instead of divide behavior
opt.iskeyword:append("-")

opt.showmode = false

-- auto completion menu height
vim.opt.pumheight = 10

require("lazy").setup {
	{ import = "plugins" },
	{ import = "plugins.lsp" },
}

require("keymaps")

local signs = {
	Error = "✘",
	Warn = "▲",
	Hint = "⚑",
	Info = "»",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config {
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	virtual_text = false,
}

vim.lsp.set_log_level("error")
