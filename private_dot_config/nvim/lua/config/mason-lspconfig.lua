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

M.setup = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
      "ruby_ls",
      "ruff_lsp",
      "rubocop",
      "astro",
      "vale_ls",
      "pyright",
      "solargraph",
      "tailwindcss",
      "stimulus_ls",
      "html",
      "tsserver",
      "yamlls",
      "emmet_ls",
      "cssls",
      "biome",
      "tsserver",
    },
  })

  require("lspconfig").lua_ls.setup {}
  require("lspconfig").ruby_ls.setup {
    cmd = ruby_lsp_command,
  }
  require("lspconfig").ruff_lsp.setup {}
  require("lspconfig").rubocop.setup {}
  require("lspconfig").astro.setup {}
  require("lspconfig").vale_ls.setup {}
  require("lspconfig").pyright.setup {}
  require("lspconfig").solargraph.setup {
    cmd = solargraph_command,
  }

  -- HTML/CSS/JS
  require('lspconfig').tailwindcss.setup {
    userLanguages = {
      eelixir = "html-eex",
      eruby = "erb",
      ruby = "erb",
      templ = "html"
    }
  }
  require('lspconfig').stimulus_ls.setup {
    filetypes = { "html", "eruby", "blade", "php" },
    flags = {
      debounce_text_changes = 150,
    }
  }
  require'lspconfig'.html.setup {
    capabilities = capabilities,
    filetypes = { "html", "templ", "eruby" },
  }
  require("lspconfig").yamlls.setup {}
  require("lspconfig").emmet_ls.setup {}
  require'lspconfig'.cssls.setup {
    capabilities = capabilities,
    filetypes = { "html", "templ", "eruby" },
  }
  require("lspconfig").biome.setup {
    single_file_support = true
  }
  require("lspconfig")["tsserver"].setup {}
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
