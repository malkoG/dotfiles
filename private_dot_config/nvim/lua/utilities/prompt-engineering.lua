local M = {}

M.generate_commit_message = function(language)
  local prompt = [[
      Using the following git diff generate a consise and
      clear git commit message, with a short title summary
      that is 75 characters or less
  ]] .. " and you should generate commit message in " .. language .. [[:
  ]] .. [[
  ```
  ]] .. vim.fn.system("git diff --cached")
  .. [[
  ```
  And you shoud give me commit message immediately.
  And you don't need to explain unnecessary things.
  ]]

  return prompt
end

M.generate_docstring = function(language, docstring_format)
  local buffer = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(buffer, "filetype")
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

  print(language, docstring_format);
  local docstring_format_references = {
    ["yard"] = "https://www.rubydoc.info/gems/yard/file/docs/Tags.md#tag-reference",
    ["numpy"] = "https://numpydoc.readthedocs.io/en/latest/format.html",
    ["pdoc"] = "https://pdoc3.github.io/pdoc/doc/pdoc/#docstring-formats",
    ["restructuredtext"] = "https://www.python.org/dev/peps/pep-0287/",
    ["javadoc"] = "https://www.oracle.com/technical-resources/articles/java/javadoc-tool.html",
    ["phpdoc"] = "https://docs.phpdoc.org/latest/references/phpdoc/basic-syntax.html",
    ["jsdoc"] = "https://jsdoc.app/tags-example.html",
  }

  local docstring_format_reference = docstring_format_references[docstring_format];

  local additional_prompt_about_docstring_format = ""

  if docstring_format_reference ~= nil then
    additional_prompt_about_docstring_format = [[
      And I strongly recommend you to use tag notation if it exists.
      For more information about the docstring format, please refer to:
      ]] .. docstring_format_reference .. [[
    ]]
  end

  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  local lines_to_format = {}
  for i = start_line, end_line do
	table.insert(lines_to_format, lines[i])
  end

  local code_snippet = table.concat(lines_to_format, "\n")
  local prompt = [[
      This code snippet is written in ]] .. filetype .. [[.
      Using the following code snippets generate a consise and clear docstring comment that consists of these:

	  1. A identifier of the function/class/method (Essential)
	  2. A short summary of the function/class/method (Essential)
	  3. A description of the function/class/method (Essential)
	  4. A list of parameters and their types (Essential)
	  5. A list of return values and their types (Essential)
	  6. A list of exceptions that can be raised (Optional)
	  7. A list of side effects (Optional)
	  8. A list of restrictions (Optional)
	  9. A list of examples (Optional)
	  10. A list of references (Optional)

  ]] .. " and you should generate docstring in " .. language .. " and its docstring format should be " .. docstring_format .. additional_prompt_about_docstring_format .. [[:
  ]] .. [[
  ```
  ]] .. code_snippet .. [[
  ```
  And you shoud give me docstring immediately.
  And you don't need to explain unnecessary things.
  And don't use qoute to answer this question.
  **AND DON'T INCLUDE CODE SNIPPET IN YOUR ANSWER.**
  YOU SHOULD ANSWER THIS QUESTION IN DOCSTRING ONLY.
  PLEASE DON'T INCLUDE YOUR COMMENT IN YOUR ANSWER.
  **IF THERE IS LINE BREAK, YOU SHOULD FORMAT IT AS DOCSTRING FORMAT.**
  ]]

  return prompt
end

return M
