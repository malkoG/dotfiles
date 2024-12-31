os = require('os')

M = {}

require("neodev").setup({})

local ruby_lsp_local = os.getenv("RUBY_LSP_LOCAL")
local ruby_lsp_command = {}
local solargraph_command = {}

local home_path = os.getenv("HOME")
if ruby_lsp_local == "true" then
  ruby_lsp_command = { "bundle", "exec", "ruby-lsp" }
else
  ruby_lsp_command = { "ruby" }
end

if ruby_lsp_local == "true" then
  solargraph_command = { "bundle", "exec", "solargraph", "stdio" }
else
  solargraph_command = { "solargraph", "stdio" }
end

local steep_enabled = os.getenv("STEEP_ENABLED")

M.setup = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
      "ruby_lsp",
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
      "zls",
    },
  })

  require("lspconfig").lua_ls.setup {}
  require("lspconfig").ruby_lsp.setup {
    filetypes = { "ruby", "eruby" },
    cmd = ruby_lsp_command,
  }
  if steep_enabled == "true" then
    require("lspconfig").steep.setup {}
  end
  require("lspconfig").ruff.setup {}
  require("lspconfig").rubocop.setup {}
  require("lspconfig").astro.setup {}
  -- require("lspconfig").vale_ls.setup {
    -- filetypes = {
      -- "markdown",
      -- "text",
      -- "typst",
      -- "rst",
      -- "asciidoc",
      -- "adoc",
      -- "ad"
    -- },
  -- }
  require("lspconfig").pyright.setup {}
  require("lspconfig").solargraph.setup {
    cmd = solargraph_command,
  }

  require('lspconfig').stimulus_ls.setup {
    filetypes = { "html", "eruby", "blade", "php" },
    flags = {
      debounce_text_changes = 150,
    }
  }

  local mason_registry = require('mason-registry')
  local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
  require("lspconfig")["ts_ls"].setup {
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vue_language_server_path,
          languages = { 'vue' },
        },
      },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  }

  require("lspconfig")["volar"].setup{}

  require("lspconfig").biome.setup {}

  -- HTML/CSS/JS
  require('lspconfig').tailwindcss.setup {
    userLanguages = {
      eelixir = "html-eex",
      eruby = "erb",
      ruby = "erb",
      templ = "html",
      jinja = "html",
      javascript = "javascriptreact",
    }
  }
  require'lspconfig'.html.setup {
    capabilities = capabilities,
    filetypes = { "html", "templ", "eruby" }
  }
  require("lspconfig").yamlls.setup {}
  require("lspconfig").emmet_ls.setup {}
  require'lspconfig'.cssls.setup {
    capabilities = capabilities,
    filetypes = { "html", "templ", "eruby" },
  }
  require("lspconfig")["terraformls"].setup{}
  require("lspconfig")["jinja_lsp"].setup{}
  require("lspconfig")["zls"].setup{}

  if ruby_lsp_local == "true" then
    -- require("lspconfig").solargraph.setup {
    --   cmd = solargraph_command,
    --   filetypes = { "ruby" },
    --   flags = {
    --     debounce_text_changes = 150,
    --   }
    -- }
  end
end

return M
