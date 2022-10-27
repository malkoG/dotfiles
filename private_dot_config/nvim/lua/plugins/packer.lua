vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
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

	-- Zettelkasten
	use {
		'renerocksai/telekasten.nvim',
		requires = { 'renerocksai/calendar-vim' },
	}

  -- Developer Experience
  use { "glepnir/dashboard-nvim" }
  use { "gpanders/editorconfig.nvim" }

	use {
		'nvim-treesitter/nvim-treesitter',
		config = function()
		  require("plugins.treesitter")
		end,
	}
	use {
		'nvim-treesitter/nvim-treesitter-context',
		config = function()
		 require("plugins.treesitter-context")
		end,
	} -- sticky scroll

	-- Git utility
	use { "APZelos/blamer.nvim" }
	use { "tpope/vim-fugitive" }

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

	-- languages (elixir)
	use	{ "elixir-editors/vim-elixir" }

	-- languages (kotlin)
	use { "udalov/kotlin-vim" }

  -- Telescope extensions
  use { "nvim-telescope/telescope-file-browser.nvim" }

end)
