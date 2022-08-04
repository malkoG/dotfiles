vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use {
	'nvim-telescope/telescope.nvim', tag = '0.1.0',
	requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { 'neoclide/coc.nvim', branch = 'release' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'kdheepak/tabline.nvim',
    config = function()
      require'tabline'.setup {enable = false}
    end,
  }
end)
