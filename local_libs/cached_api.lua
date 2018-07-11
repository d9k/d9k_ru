local sailor = require 'sailor'

local conf = require 'conf.conf'

local M = {}

M._redis_prefix = function()
  return conf.sailor.app_name . '_'
end

M.lastfm_recent_tracks = function()
  local redis_key = M._redis_prefix() .. 'lastfm_recent_tracks'


end

return M