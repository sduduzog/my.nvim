return {
  'laytan/tailwind-sorter.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
  build = 'cd formatter && npm ci && npm run build',
  config = function()
    require('tailwind-sorter').setup({
      on_save_enabled = true,                   -- If `true`, automatically enables on save sorting.
      on_save_pattern = { '*.ex', '*.heex', },  -- The file patterns to watch and sort.
      trim_spaces = false,                      -- If `true`, trim any extra spaces after sorting.
    })
  end,
}
