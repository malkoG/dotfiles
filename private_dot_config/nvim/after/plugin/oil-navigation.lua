local oil = require("oil")

local default_opts = { noremap = true, silent = true }
local opts = default_opts

local term_on_current_dir = function()
  local current_dir = oil.get_current_dir(0)
  print(current_dir);
  if current_dir then
    vim.api.nvim_command("vsplit | term") -- Open terminal in a horizontal split
    vim.fn.chansend(vim.b.terminal_job_id, "cd " .. current_dir .. "\n") -- Send the `cd` command to the terminal

  else
    print("Error: Unable to get the current directory.")
  end
end


vim.api.nvim_create_autocmd(
  'FileType',
  {
    pattern = 'oil',
    desc = 'Open current directory in terminal mode',
    callback = function(event)
      vim.api.nvim_create_user_command("TermOnCurrentDir", term_on_current_dir, {})
	  vim.keymap.set("n", "<leader>Tt", "<Cmd>TermOnCurrentDir<CR>", opts)
    end
  }
)
