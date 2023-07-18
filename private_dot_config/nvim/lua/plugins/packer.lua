vim.cmd [[packadd packer.nvim]]

local home_path = os.getenv("HOME")

return require('packer').startup(function(use)
  use {
    "~/neovim-plugin/vault.nvim",
    config = function()
      -- With this configuration, you can setup your environment varaibles safely without exposing them to the world
      require("vault").setup({
        key_path = home_path .. "/.local/share/vault.key",
        encrypted_file_path = home_path .. "/.local/share/vault.json.enc"
      })
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { 'neoclide/coc.nvim', branch = 'release' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'kdheepak/tabline.nvim',
    config = function()
      require'tabline'.setup {enable = false}
    end,
  }
  use { "ahmedkhalf/project.nvim" }
  use {
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup()
    end
  }
  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  use {
    'justinhj/battery.nvim',
    requires = {
      {'kyazdani42/nvim-web-devicons'},
      {'nvim-lua/plenary.nvim'}
    },
    config = function()
      require('battery').setup({
        update_rate_seconds = 30,           -- Number of seconds between checking battery status
        show_status_when_no_battery = true, -- Don't show any icon or text when no battery found (desktop for example)
        show_plugged_icon = true,           -- If true show a cable icon alongside the battery icon when plugged in
        show_unplugged_icon = true,         -- When true show a diconnected cable icon when not plugged in
        show_percent = true,                -- Whether or not to show the percent charge remaining in digits
        vertical_icons = true,              -- When true icons are vertical, otherwise shows horizontal battery icon
        multiple_battery_selection = 1,
      })
    end
  }

  -- Theme
  use { "savq/melange" }
  use { "tribela/vim-transparent" }

  -- Zettelkasten
  use {
    'renerocksai/telekasten.nvim',
    requires = { 'renerocksai/calendar-vim' },
  }

  -- Productivity
  use { 'wakatime/vim-wakatime' }
  use { 'github/copilot.vim' }
  use {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup({
        -- optional configuration
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "~/neovim-plugin/vault.nvim"
    }
  }
  use {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require'mind'.setup({
        persistence = {
          state_path = "/home/kodingwarrior/Dropbox/mind-vault/mind.json",
          data_dir = "/home/kodingwarrior/Dropbox/mind-vault/data",
        }
      })
    end
  }

  -- Assists developing treesitter-based tools
  use {
    "nvim-treesitter/playground",
    requires = "nvim-treesitter/nvim-treesitter"
  }

  -- Developer Experience
  use { "gpanders/editorconfig.nvim" }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require("plugins.treesitter")
    end,
  }
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
     require("plugins.treesitter-context")
    end,
  } -- sticky scroll
  use { "danilamihailov/beacon.nvim" }
  use { "cappyzawa/trim.nvim" }

  -- for super fast code navigation
  use {
    "ggandor/leap.nvim",
    requries = { "tpope/vim-repeat" },
    config = function()
      require('leap').add_default_mappings()
    end
  }

  -- persistent database for yanks
  use({
    "gbprod/yanky.nvim",
    requires = { "kkharji/sqlite.lua" },
    config = function()
      require("yanky").setup({
        ring = {
          history_length = 100,
          storage = "sqlite",
          sync_with_numbered_registers = true,
          cancel_event = "update",
        },
        system_clipboard = {
          sync_with_ring = true,
        },
      })
    end
  })
  -- use({
  --  'sunjon/shade.nvim',
  --  config = function()
  --    require'shade'.setup({
  --      overlay_opacity = 0,
  --      opacity_step = 1,
  --      keys = {
  --        brightness_up    = '<C-Up>',
  --        brightness_down  = '<C-Down>',
  --      }
  --    })
  --  end
  -- })

  -- Git utility
  use { "APZelos/blamer.nvim" }
  use { "tpope/vim-fugitive" }
  use { "airblade/vim-gitgutter" }
  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function ()
      require"octo".setup({
        pull_requests = {
          order_by = {                           -- criteria to sort the results of `Octo pr list`
            field = "CREATED_AT",                -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
            direction = "DESC"                   -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
          },
          always_select_remote_on_create = "false" -- always give prompt to select base remote repo when creating PRs
        },
      })
    end
  }

  -- for neovim plugin development
  use {
    'folke/neodev.nvim',
    requires = { "neovim/nvim-lspconfig" },
    config = function()
      require('neodev').setup({})
    end
  }

  -- Made by malkoG
  use {
    "~/neovim-plugin/mastodon.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("mastodon").setup()
    end
  }
  use {
    "~/neovim-plugin/aladin.nvim",
    requires = {
      "Olical/aniseed",
      "nvim-lua/plenary.nvim",
      'nvim-telescope/telescope.nvim',
    },
    run = "make",
  }

  -- Testing
  use { "malkoG/vim-test", branch = 'master' }
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  }

  -- Snippet generation
  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opt = true,
    config = function()
      require("config.snip").setup()
      require("config.cmp").setup()
      require('config.snippets')
    end,
    wants = { "LuaSnip" },
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "L3MON4D3/LuaSnip",
        wants = { "friendly-snippets", "vim-snippets" },
      },
      "rafamadriz/friendly-snippets",
      "honza/vim-snippets",
    },
    disable = false,
  }
  -- languages (ruby)
  use { "tpope/vim-rails" }
  use { "vim-ruby/vim-ruby" }
  use {
    "weizheheng/ror.nvim",
    requires = { "stevearc/dressing.nvim" }
  }

  -- languages (rust)
  use {
    'simrat39/rust-tools.nvim',
    config = function()
      require("rust-tools").setup({})
    end
  }

  -- languages (elixir)
  use { "elixir-editors/vim-elixir" }

  -- languages (kotlin)
  use { "udalov/kotlin-vim" }

  -- languages (dart/flutter)
  use {
    'akinsho/flutter-tools.nvim',
    config = function()
      require("flutter-tools").setup{}
    end,
    requires = {
      'nvim-lua/plenary.nvim',
    }
  }

  -- languages (fennel)
  use { "bakpakin/fennel.vim" }

  -- languages (typescript)
  use { 'nikvdp/ejs-syntax' }

  -- languages (purescript)
  use { "purescript-contrib/purescript-vim" }
  use { "vmchale/dhall-vim" }

  -- languages (rescript)
  use { 'rescript-lang/vim-rescript' }

  -- Telescope extensions
  use { "nvim-telescope/telescope-file-browser.nvim" }


  -- Infrastructure
  use {
    "skanehira/denops-docker.vim",
    requires = {
      "vim-denops/denops.vim",
    }
  }
end)
