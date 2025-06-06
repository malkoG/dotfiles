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

  require("lspconfig").lua_ls.setup {}
  require("lspconfig").ruby_lsp.setup {
    filetypes = { "ruby", "eruby" },
    mason = false,
    cmd = ruby_lsp_command,
  }
  if steep_enabled == "true" then
    require("lspconfig").steep.setup {}
  end
  require("lspconfig").ruff.setup {}
  require("lspconfig").rubocop.setup {
    mason = false,
    cmd = {"bundle", "exec", "rubocop", "stdin" }
  }
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
    mason = false,
    cmd = solargraph_command,
  }

  require('lspconfig').stimulus_ls.setup {
    filetypes = { "html", "eruby", "blade", "php" },
    flags = {
      debounce_text_changes = 150,
    }
  }

  local deno_root_dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc")(vim.fn.expand("%:p:h"))
  local deno_runtime_enabled = deno_root_dir ~= nil
  if not deno_runtime_enabled then
	require("lspconfig")["ts_ls"].setup {
	  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
	}
  end

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
    require("lspconfig").solargraph.setup {
      mason = false,
      cmd = solargraph_command,
      filetypes = { "ruby" },
      flags = {
        debounce_text_changes = 150,
      }
    }
  end

  require("lspconfig").denols.setup {}
end

return M
