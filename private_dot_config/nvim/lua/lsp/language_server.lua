local is_deno_runtime = false

-- look up parent directories for a deno.json or deno.jsonc file
-- to determine if we are in a Deno project
do
  local cwd = vim.fn.getcwd()
  local deno_config_files = { "deno.json", "deno.jsonc" }
  local function is_deno_project(dir)
    for _, config_file in ipairs(deno_config_files) do
      if vim.fn.filereadable(vim.fn.join({ dir, config_file }, "/")) == 1 then
        return true
      end
    end
    return false
  end

  local dir = cwd
  -- if .git is reached, stop searching
  while true do
    if is_deno_project(dir) then
      is_deno_runtime = true
      break
    end
    if vim.fn.isdirectory(vim.fn.join({ dir, ".git" }, "/")) == 1 then
      break
    end

	if dir == vim.env.HOME then
    break
	end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
end

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
    disable_on_deno_runtime = true,
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
  },
  {
    name = "denols",
    disable_on_deno_runtime = false,
    configuration = {
      cmd = { "deno", "lsp" },
      filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
      root_markers = { "deno.json", "deno.jsonc", ".git" },
      settings = {
        deno = {
          enable = true,
        },
      }
    }
  }
}

local available_servers = {}

for _, server in ipairs(language_servers) do
  if server.disable_on_deno_runtime == nil then
    vim.lsp.config[server.name] = server.configuration
    table.insert(available_servers, server.name)
  else
    if is_deno_runtime then
      if server.disable_on_deno_runtime then
      -- Skip enabling this server
      else
        vim.lsp.config[server.name] = server.configuration
        table.insert(available_servers, server.name)
      end
    else
      if server.disable_on_deno_runtime == false then
        -- Skip enabling this server
      else
        vim.lsp.config[server.name] = server.configuration
        table.insert(available_servers, server.name)
      end
    end
  end
end

for _, server_name in ipairs(available_servers) do
  vim.lsp.enable(server_name)
end
