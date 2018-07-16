local cached_api = require 'local_libs.cached_api'
local conf = require 'conf.conf'

local M = {}

M.lastfm_recent = function(page)
  local result = cached_api.lastfm_recent_tracks()

  -- already contained at .recentTracks['@attr'].{user/total}
--  result.userInfo = {
--    name = conf.lastfm.site_author_lastfm_login
--  }

  page:json(result)
end

return M