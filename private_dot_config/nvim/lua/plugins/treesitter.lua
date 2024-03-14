require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "c",
    "lua",
    "rust",
    "cpp",
    "java",
    "kotlin",
    "javascript",
    "python",
    "elixir",
    "kotlin",
    "fennel",
    "hcl",
  },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>n"] = "@function.outer",
      },
      swap_previous = {
        ["<leader>N"] = "@function.outer",
      },
    },
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  ignore_install = { "typescript" },

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
    disable = { "typescript", "markdown" },
  },
}

