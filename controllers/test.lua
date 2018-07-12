-- TODO access for admin only: write an admin_controller
local test = {}

local conf = require "conf.conf"
local pretty_format = require "thirdparty_libs.pprint".pformat

--local debug_mode = false
--local breakpoints = conf.debug.breakpoints and debug_mode

--if breakpoints then require('mobdebug').start('127.0.0.1') end

local sailor = require 'sailor'
local access = require 'sailor.access'
local db = require 'sailor.db'
local sailor_helpers = require 'helpers.sailor'
local json = require('cjson')

function test.index(page)
  page:render('index')
end

function test.log(page)

  local t = {test = {table = 1}}

  sailor.log:info("some", "info")
  sailor.log:info("t = " .. pretty_format(t))
--  sailor.log:info_dump(t)
--  sailor.log:info("sailor.test = " .. sailor.test)
  sailor.log:error("must be red")

  sailor.log:info("conf = " .. pretty_format(conf))

  page:render('log')
end

function test.db_query(page)
  query = 'SELECT 5*2;';

  db.connect()
  local result = db.query_one(query);
  db.close()

  page:render('db_query', {query = query, result = result})
end

function test.url_params(page)
  local output = ''
  output = output .. 'GET = ' .. pretty_format(page.GET) .. "\n"

  page:render('url_params', {output=output})
end

function test.lastfm(page)
  if sailor_helpers.render_error_if_not_logined(page) then
    return
  end

  local lastfm_conf = conf.lastfm

  local lastfm = require 'thirdparty_libs.lastfm'
  lastfm.log_function = function (...)
    sailor.log:info(...)
  end

--  local response = lastfm.auth(
--    lastfm_conf.lastfm_api_key,
--    lastfm_conf.lastfm_shared_secret,
--    lastfm_conf.lastfm_api_login,
--    lastfm_conf.lastfm_api_password
--  )

  local response = lastfm.user_get_recent_tracks(
    lastfm_conf.lastfm_api_key,
    lastfm_conf.site_author_lastfm_login
  )

  local json_result = response.text
  local result = json.decode(json_result)

  sailor.log:info('test/lastfm: lastfm.user_get_recent_tracks: '..pretty_format(result))

  page:render('lastfm', {response_dump = pretty_format(response)})
end

function test.lastfm_cached(page)
  if sailor_helpers.render_error_if_not_logined(page) then
    return
  end

  local cached_api = require 'local_libs.cached_api'

  local recent_tracks, cached = cached_api.lastfm_recent_tracks()

--  sailor.log:info('test/lastfm: lastfm.user_get_recent_tracks: '..pretty_format(result))

  page:render('lastfm_cached', {
    recent_tracks = pretty_format(recent_tracks),
    cached = cached
  })
end

function test.not_found(page, action)
  page:render('not_found', {action = action})
end

return test
