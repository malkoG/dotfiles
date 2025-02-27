vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

-- format on save for frontend
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.{ts,js,vue,jsx,tsx}",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- format on save for ruby
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.{rb}",
  callback = function()
    vim.lsp.buf.format()
    vim.cmd("silent !gem list -i rbs-inline && bundle exec rbs-inline --output %")
  end,
})

-- format on save for erb
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.{erb}",
  callback = function()
    -- run "bundle exec htmlbeautifier %" if htmlbeautifier is installed
    -- and update buffer imeediately
    vim.cmd("write!")
    vim.cmd("silent !gem list -i htmlbeautifier && htmlbeautifier %")
    vim.cmd("edit!")
  end,
})

-- require("lsp.config")
require("lsp.diagnostic")
