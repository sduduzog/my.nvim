return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'nvim-treesitter/nvim-treesitter-context',
  },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'c', 'css', 'eex', 'elixir', 'heex', 'lua', 'go', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'vue', 'typescript' },
      context = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      autotag = {
        enable = true,
        filetypes = {
          'html',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'vue',
        },
      },
      rainbow = {
        enable = true,
        disable = { 'html' },
        extended_mode = false,
        max_file_lines = nil,
      },
    }
  end,
}
