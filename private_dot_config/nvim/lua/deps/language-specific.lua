return {
  -- languages (ruby)
  { "tpope/vim-rails" },
  { "vim-ruby/vim-ruby" },
  {
    "weizheheng/ror.nvim",
    dependencies = { "stevearc/dressing.nvim" }
  },
  { 'simrat39/rust-tools.nvim', },
  { "elixir-editors/vim-elixir" },
  {
    'akinsho/flutter-tools.nvim',
    opts = {
      lsp = {
        color = { -- show the derived colours for dart variables
          enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          background = true, -- highlight the background
          background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          foreground = true, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = "■", -- the virtual text character to highlight
        },
        capabilitties = function(config)
          config.textDocument.inlayHint.dynamicRegistration = false
          config.textDocument.formatting.dynamicRegistration = true
          return config
        end,
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end,
        settings = {
          lineLength = 120,
          showTodos = true,
        }
      }
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  -- languages (fennel)
  { "bakpakin/fennel.vim" },

  -- languages (typescript)
  { 'nikvdp/ejs-syntax' },

  -- languages (purescript)
  { "purescript-contrib/purescript-vim" },
  { "vmchale/dhall-vim" },

  -- languages (rescript)
  { 'rescript-lang/vim-rescript' },

  -- languages (jinja2)
  { 'Glench/Vim-Jinja2-Syntax' },

  -- languages (kotlin)
  { "udalov/kotlin-vim" }
}
