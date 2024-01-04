-- navigating between buffers
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<leader>]", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>[", ":bp<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })
