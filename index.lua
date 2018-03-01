local sailor = require "sailor"

local conf = require "conf.conf"
local debug = false
local breakpoints = conf.debug.breakpoints and debug

if breakpoints then
--if true then
  require('mobdebug').start('127.0.0.1')
end

sailor.launch()