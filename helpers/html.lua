htmlEntities = require('htmlEntities')

local M = {}

function M.html_encode(s)
  if not s then
    s = ''
  end
  return htmlEntities.encode(s)
end

return M