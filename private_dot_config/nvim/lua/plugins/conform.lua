local custom_formatters = {}

local poetry_enabled = os.getenv("POETRY_ACTIVE") == "true"
if poetry_enabled then
  custom_formatters["poetry_ruff"] = {
    command = "poetry",
    args = { "run", "ruff", "format", "--stdin-filename", "$FILENAME" },
    cwd = require("conform.util").root_file({ ".editorconfig", "pyproject.toml" }),
  }
end

require("conform").setup({
  formatters = custom_formatters,
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "poetry_ruff" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    ["*"] = { "trim_whitespace" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
})
