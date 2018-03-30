-- TODO access for admin only
local test = {}

local conf = require "conf.conf"
local pformat = require "thirdparty_libs.pprint".pformat

--local debug_mode = false
--local breakpoints = conf.debug.breakpoints and debug_mode

--if breakpoints then require('mobdebug').start('127.0.0.1') end

local sailor = require 'sailor'
local db = require 'sailor.db'

function test.index(page)
  page:render('index')
end

function test.log(page)

  local t = {test = {table = 1}}

  sailor.log:info("some", "info")
  sailor.log:info("t = " .. pformat(t))
--  sailor.log:info_dump(t)
--  sailor.log:info("sailor.test = " .. sailor.test)
  sailor.log:error("must be red")

  sailor.log:info("conf = " .. pformat(conf))

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
  output = output .. 'GET = ' .. pformat(page.GET) .. "\n"

  page:render('url_params', {output=output})
end

return test
