local cached_api = require 'local_libs.cached_api'
local conf = require 'conf.conf'

local M = {}

M.flickr_last_public_photos = function(page)
  local result = cached_api.flickr_last_public_photos()

  page:json(result)
end

return M