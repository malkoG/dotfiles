return {
  { 'nvim-treesitter/nvim-treesitter' },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = {
      {'nvim-lua/plenary.nvim'}
    }
  },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-pack/nvim-spectre" },
  { "tribela/vim-transparent" },
  { 'github/copilot.vim' },
  { "stevearc/oil.nvim", },
  -- {
  --   "Bryley/neoai.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --
  --   opts = {
  --     -- Below are the default options, feel free to override what you would like changed
  --     ui = {
  --         output_popup_text = "NeoAI",
  --         input_popup_text = "Prompt",
  --         width = 30, -- As percentage eg. 30%
  --         output_popup_height = 80, -- As percentage eg. 80%
  --         submit = "<Enter>", -- Key binding to submit the prompt
  --     },
  --     models = {
  --         {
  --             name = "openai",
  --             model = "gpt-4o",
  --             params = nil,
  --         },
  --     },
  --     register_output = {
  --         ["g"] = function(output)
  --             return output
  --         end,
  --         ["c"] = require("neoai.utils").extract_code_snippets,
  --     },
  --     inject = {
  --         cutoff_width = 75,
  --     },
  --     prompts = {
  --         context_prompt = function(context)
  --             return "Hey, I'd like to provide some context for future "
  --                 .. "messages. Here is the code/text that I want to refer "
  --                 .. "to in our upcoming conversations:\n\n"
  --                 .. context
  --         end,
  --     },
  --     mappings = {
  --         ["select_up"] = "<C-k>",
  --         ["select_down"] = "<C-j>",
  --     },
  --     open_ai = {
  --         api_key = {
  --             env = "OPENAI_API_KEY",
  --             value = nil,
  --             -- `get` is is a function that retrieves an API key, can be used to override the default method.
  --             -- get = function() ... end
  --
  --             -- Here is some code for a function that retrieves an API key. You can use it with
  --             -- the Linux 'pass' application.
  --             -- get = function()
  --             --     local key = vim.fn.system("pass show openai/mytestkey")
  --             --     key = string.gsub(key, "\n", "")
  --             --     return key
  --             -- end,
  --         },
  --     },
  --   },
  --   lazy = true
  -- },
  {
    "yetone/avante.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      }
    },
    run = "make",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = "copilot",
      auto_suggestion_provider = "copilot",
    },
  },
  { "gpanders/editorconfig.nvim" },
  { "echasnovski/mini.files" },
  { "cappyzawa/trim.nvim" },
  {
    "folke/paint.nvim",
    opts = require("config.painting_rules"),
  },
  {
    "rest-nvim/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    opts = {
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
    }
  },
  -- for super fast code navigation
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
  },

  -- persistent database for yanks
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {
      ring = {
        history_length = 100,
        storage = "sqlite",
        sync_with_numbered_registers = true,
        cancel_event = "update",
      },
      system_clipboard = {
        sync_with_ring = true,
      },
    }
  },
  -- Git utility
  { "APZelos/blamer.nvim" },
  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },
  {
    "folke/trouble.nvim",
  },
  { 'brenoprata10/nvim-highlight-colors' },
  { "malkoG/vim-test", branch = 'master' }
}
