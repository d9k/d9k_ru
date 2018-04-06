htmlEntities = require('htmlEntities')

local M = {}

function M.html_encode(s)
  return htmlEntities.encode(s)
end

return M