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
  {
    name = 'lua_ls',
    configuration = {
      settings = {
        lua_ls = {
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
        },
      }
    }
  }
}

for _, server in ipairs(language_servers) do
  vim.lsp.config[server.name] = server.configuration
end

for _, server in ipairs(language_servers) do
  vim.lsp.enable(server.name)
end
