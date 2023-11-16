local M = {}

M.concat = function(arr1, arr2)
  for _, element in ipairs(arr2) do
    arr1[#arr1 + 1] = element
  end

  return arr1
end

return M
