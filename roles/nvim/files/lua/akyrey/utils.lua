local M = {}

-- Checks if file package.json exists and contains given field
-- @param field (string) field to search for
-- @returns (bool)
function M.is_in_package_json(field)
  if vim.fn.filereadable(vim.fn.getcwd() .. "/package.json") ~= 0 then
    local package_json = vim.fn.json_decode(vim.fn.readfile "package.json")
    if package_json[field] ~= nil then
      return true
    end
    local dev_dependencies = package_json["devDependencies"]
    if dev_dependencies ~= nil and dev_dependencies[field] ~= nil then
      return true
    end
    local dependencies = package_json["dependencies"]
    if dependencies ~= nil and dependencies[field] ~= nil then
      return true
    end
  end
  return false
end

return M
