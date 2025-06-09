return {
  'mason-org/mason-lspconfig.nvim',
  opts = {
    ensure_installed = { 'elixirls', 'eslint', 'gopls', 'lua_ls', 'bashls', 'tailwindcss', 'emmet_language_server', 'vue_ls', 'ts_ls' },
  },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'neovim/nvim-lspconfig',
  },
}
