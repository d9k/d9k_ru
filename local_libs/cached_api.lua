local sailor = require 'sailor'
local conf = require 'conf.conf'
local json = require 'cjson'

local M = {
  debug = true,
  LAST_FM_RECENT_TRACKS_CACHE_TIME_SEC = 20,
}

M._redis_prefix = function()
  return conf.sailor.app_name .. '_'
end

M.lastfm_recent_tracks = function()
  local redis_data_key = M._redis_prefix() .. 'lastfm_recent_tracks'

  local debug_log = function(s)
    if M.debug then sailor.log:info('cached_api.lastfm_recent_tracks: ' .. s) end
  end

  local recent_tracks_json = sailor.redis:get(redis_data_key)
  local recent_tracks

  local cached = false

  if recent_tracks_json then
    debug_log('found in redis by key ' .. redis_data_key)
    cached = true
    recent_tracks = json.decode(recent_tracks_json)
  else
    debug_log('redis cache not found by key ' .. redis_data_key .. '. quering')
    local lastfm = require 'thirdparty_libs.lastfm'
    local lastfm_conf = conf.lastfm

    lastfm.log_function = function (...)
      sailor.log:info(...)
    end

    local response = lastfm.user_get_recent_tracks(
      lastfm_conf.lastfm_api_key,
      lastfm_conf.site_author_lastfm_login
    )

    local recent_tracks_json = response.text
    recent_tracks = json.decode(recent_tracks_json)

    sailor.redis:setex(
      redis_data_key,
      M.LAST_FM_RECENT_TRACKS_CACHE_TIME_SEC,
      recent_tracks_json
    )
  end

  return recent_tracks, cached
end

return M