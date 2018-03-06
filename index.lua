local conf = require 'conf.conf'

local debug_mode = true
local breakpoints = conf.debug.breakpoints and debug_mode
if breakpoints then require('mobdebug').start('127.0.0.1') end

local sailor = require 'sailor'

local log_from_config = require 'log_from_config'

-- whill be restored in any file if you call `local sailor = require 'sailor'`
sailor.log = log_from_config.log_from_config(conf.log)
sailor.log:info('log created')

sailor.launch()