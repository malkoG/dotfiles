local language_servers = {
  -- {
  --   name = 'ty',
  --   configuration = {
  --     cmd = { 'uv', 'run', 'ty', 'server' },
  --     filetypes = { 'python' },
  --     settings = {
  --       ty = {
  --         lint = {
  --           enabled = true,
  --         },
  --         experimental = {
  --           autoImport = true,
  --         },
  --       },
  --     },
  --   },
  -- },
  {
    name = 'basedpyright',
    configuration = {
      cmd = { 'uv', 'run', 'basedpyright-langserver', '--stdio' },
      root_markers = { 'pyproject.toml' },
      filetypes = { 'python' },
      settings = {
        basedpyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
          },
        },
      },
    },
  },
  {
    name = 'ruff',
    configuration = {
      cmd = { 'uv', 'run', 'ruff', 'server' },
      filetypes = { 'python' },
      root_markers = { 'pyproject.toml', 'setup.cfg', 'tox.ini', '.ruff.toml' },
      settings = {
        ruff = {
          logLevel = 'debug',
        },
      },
    },
  },
  {
    name = "ts_ls",
    configuration = {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
      root_markers = { "package.json", ".git" },
      settings = {
        tsserver = {
          logLevel = "info",
        },
      }
    },
  }
}

for _, server in ipairs(language_servers) do
  vim.lsp.config[server.name] = server.configuration
end

for _, server in ipairs(language_servers) do
  vim.lsp.enable(server.name)
end
