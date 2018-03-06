-- TODO access for admin only
local test = {}

local conf = require "conf.conf"
local pprint = require "thirdparty_libs.pprint".pformat

local debug_mode = false
local breakpoints = conf.debug.breakpoints and debug_mode

if breakpoints then require('mobdebug').start('127.0.0.1') end

local sailor = require 'sailor'


function test.index(page)
  page:render('index')
end

function test.log(page)

  local t = {test = {table = 1}}

  sailor.log:info("some", "info")
  sailor.log:info("t = " .. pprint(t))
--  sailor.log:info_dump(t)
--  sailor.log:info("sailor.test = " .. sailor.test)
  sailor.log:error("must be red")

  page:render('log')
end

return test
