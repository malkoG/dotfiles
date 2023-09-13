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

return M
