-- navigating between buffers
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader><Tab>', ':bn<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader><S-Tab>', ':bp<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { desc = 'Delete buffer' })

-- save to file
vim.keymap.set('n', '<C-s>', '<Cmd>CreateNewFileFromPrompt<CR>')

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
