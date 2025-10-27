local language_servers = {
  {
    name = 'ty',
    configuration = {
      cmd = { 'uv', 'run', 'ty', 'server' },
      filetypes = { 'python' },
      settings = {
        ty = {
          lint = {
            enabled = true,
          },
          experimental = {
            autoImport = true,
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
      settings = {
        ruff = {
        },
      },
    },
  },
}

for _, server in ipairs(language_servers) do
  vim.lsp.config[server.name] = server.configuration
end

for _, server in ipairs(language_servers) do
  vim.lsp.enable(server.name)
end
