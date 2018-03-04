local sailor = require 'sailor'

local conf = require 'conf.conf'
local log_from_config = require 'log_from_config'
local debug = 0
local breakpoints = conf.debug.breakpoints and debug

if breakpoints then
--if true then
  require('mobdebug').start('127.0.0.1')
end

sailor.test = 5
sailor.launch()