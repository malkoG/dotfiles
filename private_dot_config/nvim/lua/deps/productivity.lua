return {
  { 'wakatime/vim-wakatime' },
  {
    'renerocksai/telekasten.nvim',
    dependencies = { 'renerocksai/calendar-vim' },
  },
  {
    "kode-team/mastodon.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "rcarriga/nvim-notify",
      "kkharji/sqlite.lua",
    },
    config = function()
      require("mastodon").setup()
    end
  }
}
