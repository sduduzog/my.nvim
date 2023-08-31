function platform()
  return package.config:sub(1, 1) == '\\' and 'win' or 'unix'
end

if platform() == 'win' then
  local powershell_options = {
    shell = vim.fn.executable 'pwsh' == 1 and 'pwsh' or 'powershell',
    shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
    shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait',
    shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
    shellquote = '',
    shellxquote = '',
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '

vim.opt.guifont = { 'JetbrainsMono Nerd Font', ':h15' }

local opt = vim.opt

vim.cmd [[
    filetype plugin indent on
    syntax on
]]
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
opt.background = 'dark'
opt.signcolumn = 'yes' -- enable specific highlights in debug mode

-- backspace settings
opt.backspace = 'indent,eol,start'
-- enable native clipboard instead of vim default clipboard behavior
-- opt.clipboard:append "unnamedplus"
vim.opt.clipboard:prepend { 'unnamed', 'unnamedplus' }

-- split windows
opt.splitright = true
opt.splitbelow = true

-- set dash as normal letter instead of divide behavior
opt.iskeyword:append '-'

opt.showmode = false

-- auto completion menu height
vim.opt.pumheight = 10

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader><Tab>', ':bn<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader><S-Tab>', ':bp<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Delete buffer' })

require('lazy').setup('plugins');

pcall(require, 'options')

vim.cmd.colorscheme 'catppuccin-frappe'


function split(pString, pPattern)
  local Table = {} -- NOTE: use {n = 0} in Lua-5.0
  local fpat = '(.-)' .. pPattern
  local last_end = 1
  local s, e, cap = pString:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= '' then
      table.insert(Table, cap)
    end
    last_end = e + 1
    s, e, cap = pString:find(fpat, last_end)
  end
  if last_end <= #pString then
    cap = pString:sub(last_end)
    table.insert(Table, cap)
  end
  return Table
end

function clean_path(filename)
  local pathseperator = package.config:sub(1, 1)
  return table.concat(split(filename, '/'), pathseperator)
end

vim.api.nvim_create_user_command('CreateNewFileFromPrompt', function()
    local current_filename = vim.api.nvim_buf_get_name(0)
    if current_filename ~= '' then
      print('buffer is associated with an existing file')
      return
    end
    vim.ui.input({ prompt = 'filename: ' }, function(filename)
      vim.cmd('redraw')
      print('\n') -- pretty much resetting the status line
      local file_exists = io.open(filename, 'r')
      if file_exists ~= nil then
        io.close(file_exists)
        print(string.format('%s already exists', filename))
        return
      end


      local dir = string.match(filename, '(.+)/[^/]*$')

      if dir then
        os.execute('mkdir ' .. clean_path(dir))
      end
      vim.cmd(':write ' .. filename)
    end)
  end,
  {})

vim.keymap.set('n', '<C-s>', '<Cmd>CreateNewFileFromPrompt<CR>')
