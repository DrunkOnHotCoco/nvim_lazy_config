return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {},
  },

  -- Autocompletion
  -- {
  --   'hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   config = function()
  --     local cmp = require('cmp')
  --
  --     cmp.setup({
  --       sources = {
  --         {name = 'nvim_lsp'},
  --       },
  --       mapping = cmp.mapping.preset.insert({
  --         -- ['<C-Space>'] = cmp.mapping.complete(),
  --         ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --         ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  --         ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  --         ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-d>'] = cmp.mapping.scroll_docs(4),
  --       }),
  --       snippet = {
  --         expand = function(args)
  --           vim.snippet.expand(args.body)
  --         end,
  --       },
  --     })
  --   end
  -- },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    -- dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',

    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'saghen/blink.cmp'},
      -- {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = 'yes'
    end,
    opts = {
      servers = {
          lua_ls = {
            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                  return
                end
              end

              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  }
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                  -- library = vim.api.nvim_get_runtime_file("", true)
                }
              })
            end,
            settings = {
              Lua = {}
            }
          },
          pyright = {}
        }
    },
    config = function(_, opts)
      vim.diagnostic.config {
        severity_sort = true, -- make LSP messages get a priority for signcolumn/virtual text that matches their severity
        virtual_text = true
      }
      local lspconfig = require('lspconfig')
      for server, config in pairs(opts.servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = {buffer = event.buf}

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        end,
      })
    end
    -- config = function()
    --   vim.diagnostic.config {
    --     severity_sort = true, -- make LSP messages get a priority for signcolumn/virtual text that matches their severity
    --     virtual_text = true
    --   }
    --   -- local lsp_defaults = require('lspconfig').util.default_config
    --
    --   -- Add cmp_nvim_lsp capabilities settings to lspconfig
    --   -- This should be executed before you configure any language server
    --   -- lsp_defaults.capabilities = vim.tbl_deep_extend(
    --   --   'force',
    --   --   lsp_defaults.capabilities,
    --   --   require('cmp_nvim_lsp').default_capabilities()
    --   -- )
    --
    --   -- LspAttach is where you enable features that only work
    --   -- if there is a language server active in the file
    --   vim.api.nvim_create_autocmd('LspAttach', {
    --     desc = 'LSP actions',
    --     callback = function(event)
    --       local opts = {buffer = event.buf}
    --
    --       vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    --       vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    --       vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    --       vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    --       vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    --       vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    --       vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    --       vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    --       vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    --       vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    --     end,
    --   })
    --
    --   require('lspconfig').pyright.setup({})
    --   require('lspconfig').lua_ls.setup {
    --     on_init = function(client)
    --       if client.workspace_folders then
    --         local path = client.workspace_folders[1].name
    --         if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
    --           return
    --         end
    --       end
    --
    --       client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
    --         runtime = {
    --           -- Tell the language server which version of Lua you're using
    --           -- (most likely LuaJIT in the case of Neovim)
    --           version = 'LuaJIT'
    --         },
    --         -- Make the server aware of Neovim runtime files
    --         workspace = {
    --           checkThirdParty = false,
    --           library = {
    --             vim.env.VIMRUNTIME,
    --             -- Depending on the usage, you might want to add additional paths here.
    --             "${3rd}/luv/library"
    --             -- "${3rd}/busted/library",
    --           }
    --           -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
    --           -- library = vim.api.nvim_get_runtime_file("", true)
    --         }
    --       })
    --     end,
    --     settings = {
    --       Lua = {}
    --     }
    --   }
    --       end
  }
}
