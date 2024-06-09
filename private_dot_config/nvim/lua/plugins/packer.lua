vim.cmd [[packadd packer.nvim]]

local home_path = os.getenv("HOME")
local discord_presence_mode = os.getenv("DISCORD_PRESENCE_MODE")
if discord_presence_mode == nil then
  discord_presence_mode = "office"
end

return require('packer').startup(function(use)
  -- use {
  --   "~/neovim-plugin/vault.nvim",
  --   config = function()
  --     -- With this configuration, you can setup your environment varaibles safely without exposing them to the world
  --     require("vault").setup({
  --       key_path = home_path .. "/.local/share/vault.key",
  --       encrypted_file_path = home_path .. "/.local/share/vault.json.enc"
  --     })
  --   end
  -- }

  use { 'wbthomason/packer.nvim' }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use {
    'kdheepak/tabline.nvim',
    config = function()
      require'tabline'.setup {enable = false}
    end,
  }
  use { "ahmedkhalf/project.nvim" }
  use { "nvim-pack/nvim-spectre" }
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
  use { "catppuccin/nvim", as = "catppuccin" }
  use { "folke/tokyonight.nvim" }
  use { 'AlexvZyl/nordic.nvim' }
  use { "tribela/vim-transparent" }

  -- Zettelkasten
  use {
    'renerocksai/telekasten.nvim',
    requires = { 'renerocksai/calendar-vim' },
  }

  -- Productivity
  use { 'wakatime/vim-wakatime' }
  use { 'github/copilot.vim' }
  -- use {
  --   "jackMort/ChatGPT.nvim",
  --   config = function()
  --     require("chatgpt").setup({
  --       -- optional configuration
  --     })
  --   end,
  --   requires = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   }
  -- }
  use ({
    "Bryley/neoai.nvim",
    requires = { "MunifTanjim/nui.nvim" },
    config = function()
      require("neoai").setup({
        -- Below are the default options, feel free to override what you would like changed
        ui = {
            output_popup_text = "NeoAI",
            input_popup_text = "Prompt",
            width = 30, -- As percentage eg. 30%
            output_popup_height = 80, -- As percentage eg. 80%
            submit = "<Enter>", -- Key binding to submit the prompt
        },
        models = {
            {
                name = "openai",
                model = "gpt-4o",
                params = nil,
            },
        },
        register_output = {
            ["g"] = function(output)
                return output
            end,
            ["c"] = require("neoai.utils").extract_code_snippets,
        },
        inject = {
            cutoff_width = 75,
        },
        prompts = {
            context_prompt = function(context)
                return "Hey, I'd like to provide some context for future "
                    .. "messages. Here is the code/text that I want to refer "
                    .. "to in our upcoming conversations:\n\n"
                    .. context
            end,
        },
        mappings = {
            ["select_up"] = "<C-k>",
            ["select_down"] = "<C-j>",
        },
        open_ai = {
            api_key = {
                env = "OPENAI_API_KEY",
                value = nil,
                -- `get` is is a function that retrieves an API key, can be used to override the default method.
                -- get = function() ... end

                -- Here is some code for a function that retrieves an API key. You can use it with
                -- the Linux 'pass' application.
                -- get = function()
                --     local key = vim.fn.system("pass show openai/mytestkey")
                --     key = string.gsub(key, "\n", "")
                --     return key
                -- end,
            },
        },
      })
    end,
  })
  use ({
    'chomosuke/typst-preview.nvim',
    tag = 'v0.1.*',
    run = function() require 'typst-preview'.update() end,
  })

  -- Discord Rich Presence
  use {
	"andweeb/presence.nvim",
	config = function()
	  require("presence").setup({
		main_image = "neovim",
		neovim_image_text = "King god general majesty editor",
		debounce_timeout = 100,
		show_button = discord_presence_mode == "home",

		editing_text = "" .. (discord_presence_mode == "home" and "Editing %s" or "Editing secret project"),
		file_explorer_text = "" .. (discord_presence_mode == "home" and "Browsing %s" or "Browsing secret file"),
		git_commit_text = "" .. (discord_presence_mode == "home" and "Committing changes" or ""),
		plugin_manager_text = "" .. (discord_presence_mode == "home" and "Managing plugins" or ""),
		reading_text = "" .. (discord_presence_mode == "home" and "Reading %s" or ":blobawesome:"),
		workspace_text = "" .. (discord_presence_mode == "home" and "Working on %s" or "Working on secret project"),
		line_number_text = "" .. (discord_presence_mode == "home" and "Line %s out of %s" or ":blobsad:"),
	  })
	end
  }

  -- Assists developing treesitter-based tools
  use {
    "nvim-treesitter/playground",
    requires = "nvim-treesitter/nvim-treesitter"
  }

  -- Developer Experience
  use {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end
  }
  use { "gpanders/editorconfig.nvim" }
  use { "echasnovski/mini.files" }

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
  use {
    "folke/paint.nvim",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      local rules = require("config.painting_rules")
      require("paint").setup(rules)
    end
  }

  use {
    "rest-nvim/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          -- show the generated curl command in case you want to launch
          -- the same request via the terminal (can be verbose)
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
            end
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })
    end
  }

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
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup({ top_down = false })
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
      require("mastodon").setup({
        -- keymaps = {
        --   ["system-wide-keymaps"] = {
        --     ["home-timeline"] = "<space>mh"
        --   }
        -- }
      })
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
      "hrsh7th/cmp-emoji",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "~/neovim-plugin/cmp_mermaid",
      {
        "L3MON4D3/LuaSnip",
        wants = { "friendly-snippets", "vim-snippets" },
      },
      "rafamadriz/friendly-snippets",
      "honza/vim-snippets",
    },
    disable = false,
  }

  use {
    'williamboman/mason-lspconfig.nvim',
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      'folke/neodev.nvim',
    },
    config = function()
      require("config.mason-lspconfig").setup()
      require("lsp.init")
    end
  }

  use {
    "folke/trouble.nvim",
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

  use {
    'scalameta/nvim-metals',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach({})
        end,
        group = nvim_metals_group,
      })
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
      require("flutter-tools").setup{
        lsp = {
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
          }
        }
      }
    end,
    requires = {
      'nvim-lua/plenary.nvim',
    },
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

  -- languages (jinja2)
  use { 'Glench/Vim-Jinja2-Syntax' }

  -- Telescope extensions
  use { "nvim-telescope/telescope-file-browser.nvim" }
end)
