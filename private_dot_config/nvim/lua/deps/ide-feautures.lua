return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opt = true,
    config = function()
      require("config.cmp").setup()
      require('config.snippets')
    end,
    wants = { "LuaSnip" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-emoji",
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
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      'folke/neodev.nvim',
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "steep",
        "ruff",
        "rubocop",
        "astro",
        -- "vale_ls",
        "pyright",
        "solargraph",
        "tailwindcss",
        "stimulus_ls",
        "html",
        "ts_ls",
        "yamlls",
        "emmet_ls",
        "cssls",
        "biome",
        "terraformls",
        "jinja_lsp",
        "volar",
      },
    },
    config = function()
      require("config.mason-lspconfig").setup()
      require("lsp.init")
    end
  }
}
