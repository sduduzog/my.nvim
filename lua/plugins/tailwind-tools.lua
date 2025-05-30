return {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim', -- optional
    'neovim/nvim-lspconfig',         -- optional
  },
  opts = {
    settings = {
      experimental = {
        emmetCompletions = true,
        -- classRegex = {
        --   'class[:]\\s*"([^"]*)"',
        --   'class: "([^"]*)"',
        -- },
        -- includeLanguages = {
        --   heex = 'html-eex',
        --   elixir = 'html-eex',
        -- },
      },

    }
  }, -- your configuration
}
