local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
  {
    'folke/which-key.nvim',
    opts = {}
  },
  {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    config = function()
      require('better_escape').setup()
    end,
  },
  { 'jiangmiao/auto-pairs' },
  {
    'f-person/git-blame.nvim',
    event = 'VeryLazy',
  },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        toggler = {
          line = '<leader>//',
          block = '<leader>/b'
        },
        opleader = {
          line = '//',
          block = '/b'
        },
      }
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  {
    'lewis6991/hover.nvim',
    config = function()
      require('hover').setup {
        init = function()
          require('hover.providers.lsp')
        end,
        preview_opts = {
          border = nil
        },
        preview_window = false,
        title = true
      }

      -- Setup keymaps
      vim.keymap.set('n', 'K', require('hover').hover, { desc = 'hover.nvim' })
      vim.keymap.set('n', 'gK', require('hover').hover_select, { desc = 'hover.nvim (select)' })
    end
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>gg', ':LazyGitCurrentFile<CR>', { desc = 'Open lazygit' })
    end,
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        opts = {}
      },
    },
    config = function()
      local lsp = require('lsp-zero').preset({
        name = 'recommended'
      })

      local cmp = require('cmp')

      local lspconfig = require('lspconfig')

      lsp.ensure_installed({
        'lua_ls',
        'eslint',
        'graphql',
        'gopls',
        'volar',
        'tailwindcss'
      })

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        lsp.buffer_autoformat()
      end)

      lsp.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })

      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = {
            prefix = '●',
            spacing = 4,
            severity_limit = 'Warning',
          },
          underline = true,
          signs = true,
          update_in_insert = true,
        }
      )

      lspconfig.volar.setup({
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
        settings = {
          css = {
            lint = {
              unknownAtRules = 'ignore'
            }
          },

          scss = {
            lint = {
              unknownAtRules = 'ignore'
            }
          }
        }
      })

      lspconfig.graphql.setup {}

      lspconfig.eslint.setup({
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end,
      })

      lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()

      cmp.setup({
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        },
        preselect = 'item',
        completion = {
          completeopt = 'menu, menuone, noinsert'
        }
      })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          packer = {},
          NvimTree = {},
          statusline = {},
          winbar = {}
        },
        extensions = {
          'toggleterm',
          'nvim-tree',
          'fzf'
        }
      },
    },
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        sort_by = 'case_sensitive',
        view = {
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
              return {
                border = 'rounded',
                relative = 'editor',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
          exclude = { '.env*' },
        },
      }

      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>ss', builtin.current_buffer_fuzzy_find, {})

      vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>sb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})

      vim.keymap.set('n', '<leader>sd', builtin.lsp_definitions, {})
      vim.keymap.set('n', '<leader>si', builtin.lsp_implementations, {})
    end
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup({
        open_mapping = [[<leader>;]],
        direction = 'float',
        start_in_insert = true,
        persist_size = true,
        close_on_exit = true,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
        winbar = {
          enabled = false,
          name_formatter = function(term) --  term: Terminal
            return term.name
          end,
        },
      })
    end
  },
  {
    'xiyaowong/transparent.nvim',
    config = function()
      require('transparent').setup {
        'NormalFloat',
        extra_groups = {
          'NvimTreeNormal',
          'ToggleTerm'
        }
      }
      vim.keymap.set('n', '<S-F6>', ':TransparentToggle<CR>')
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'css',
          'diff',
          'elixir',
          'go',
          'graphql',
          'html',
          'javascript',
          'json',
          'lua',
          'make',
          'markdown',
          'markdown_inline',
          'scss',
          'sql',
          'typescript',
          'vim',
          'vue'
        },
        hightlight = {
          enable = true
        },
        highlight = {
          enable = true,
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

        additional_vim_regex_highlighting = false,
        context_commentstring = {
          enable = true
        }
      }
    end
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000
  },
}
