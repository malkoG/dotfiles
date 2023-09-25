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

local textify_commit_message = function()
	vim.ui.select( 
		{ "korean", "english" },
		{
			prompt = "Select language: ",
		},
		function(language)
			if language ~= nil then 
				local prompt = require('utilities.prompt-engineering').generate_modified_commit_message(language)
				local start_line = vim.fn.line("'<")
				local end_line = vim.fn.line("'>")
				require("neoai").context_inject(prompt, nil, start_line, end_line)
			end
		end
	)
end

local inject_docstring = function()
  local docstring_formats = { 
	["python"] =  "reST" ,
	["javascript"] =  "jsdoc" ,
	["typescript"] =  "jsdoc" ,
	["typescriptreact"] =  "jsdoc" ,
	["javascriptreact"] =  "jsdoc" ,
	["c"] =  "doxygen" ,
	["cpp"] =  "doxygen" ,
	["lua"] =  "luadoc" ,
	["rust"] =  "rustdoc" ,
	["go"] =  "godoc" ,
	["java"] =  "javadoc" ,
	["php"] =  "phpdoc" ,
	["ruby"] =  "yard" ,
	["elixir"] =  "exdoc" ,
	["erlang"] =  "edoc" ,
	["clojure"] =  "codox" ,
	["haskell"] =  "haddock" ,
	["scala"] =  "scaladoc" ,
	["kotlin"] =  "kdoc" ,
	["swift"] =  "swiftdoc" ,
	["julia"] =  "juliadoc" ,
	["dart"] =  "dartdoc" ,
	["vim"] =  "vimdoc" ,
	["viml"] =  "vimdoc" ,
  }

  vim.ui.select( 
  	{"korean", "english"},
	{
	  prompt = "Select language: ",
	},
	function(language)
	  if language ~= nil then 
		local filetype = vim.bo.filetype
		local docstring_format = docstring_formats[filetype]
		local prompt = require('utilities.prompt-engineering').generate_docstring(language, docstring_format)
		local current_position = vim.api.nvim_win_get_cursor(0)
		local start_line = vim.fn.line("'<")
		vim.api.nvim_win_set_cursor(0, {start_line - 2, current_position[2]})
		require('neoai').context_inject(prompt, nil, start_line - 1, start_line - 1)
	  end
	end
  )
end

vim.api.nvim_create_user_command("InjectCommitMessage", inject_commit_message, {})
vim.api.nvim_create_user_command("TextifyCommitMessage", textify_commit_message, { range = true })
vim.api.nvim_create_user_command("InjectDocstring", inject_docstring, { range = true })


