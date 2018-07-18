local table_helpers = require 'helpers.table'
local sailor_helpers = require 'helpers.sailor'

local M = table_helpers.merge(
  require 'controllers.components.lastfm',
  require 'controllers.components.flickr'
)

M.index = function(page)
--  page:enable_cors()
  page:json({test= {1, 5, 4}})
end

return M