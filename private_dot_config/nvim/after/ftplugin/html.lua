vim.api.nvim_create_autocmd(
	{
		"BufNewFile",
		"BufRead",
	},
	{
		pattern = "*.html",
		callback = function()
			if os.getenv("USING_DJANGO_TEMPLATE") == "yes" then
				vim.api.nvim_command("setfiletype htmldjango")
			end
		end
	}
)
