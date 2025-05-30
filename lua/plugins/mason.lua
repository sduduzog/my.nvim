return {
  'mason-org/mason-lspconfig.nvim',
  opts = {
    ensure_installed = { 'elixirls', 'eslint', 'lua_ls', 'ts_ls', 'tailwindcss', 'emmet_language_server' },
  },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'neovim/nvim-lspconfig',
  },
}
