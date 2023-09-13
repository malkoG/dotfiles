local inject_commit_message = function()
	-- `vim.ui.select` function's behavior is asyncronous.
	--
	-- So, In order to generate commit message by selected language, 
	-- we have to place `generate_commit_message` inside of `vim.ui.select` function's callback
  vim.ui.select(
    {"korean", "english"},
    {
      prompt = "Select language: ",
    },
    function(language)
      if language ~= nil then
				local prompt = require('utilities.prompt-engineering').generate_commit_message(language)
				require("neoai").context_inject(prompt, nil)
      end
    end
  )
end

vim.api.nvim_create_user_command("InjectCommitMessage", inject_commit_message, {})
