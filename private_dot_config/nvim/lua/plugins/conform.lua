local custom_formatters = {}

local poetry_enabled = os.getenv("POETRY_ACTIVE") == "true"
local python_formatters = {}
if poetry_enabled then
  table.insert(python_formatters, "poetry_ruff_format")
  table.insert(python_formatters, "poetry_ruff_check")
  custom_formatters["poetry_ruff_format"] = {
    command = "poetry",
    args = { "run", "ruff", "format", "--stdin-filename", "$FILENAME" },
    cwd = require("conform.util").root_file({ ".editorconfig", "pyproject.toml" }),
  }
  custom_formatters["poetry_ruff_check"] = {
    command = "poetry",
    args = { "run", "ruff", "check", "--fix", "--stdin-filename", "$FILENAME" },
    cwd = require("conform.util").root_file({ ".editorconfig", "pyproject.toml" }),
  }
else
  table.insert(python_formatters, "ruff_format")
  table.insert(python_formatters, "ruff_check")
end

require("conform").setup({
  formatters = custom_formatters,
  formatters_by_ft = {
    lua = { "stylua" },
    python = python_formatters,
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
