local main = {}

local conf = require "conf.conf"
local pprint = require "thirdparty_libs.pprint".pformat

local debug_mode = false
local breakpoints = conf.debug.breakpoints and debug_mode

if breakpoints then require('mobdebug').start('127.0.0.1') end

local sailor = require 'sailor'

function main.index(page)

  page:render('index')
end

return main
