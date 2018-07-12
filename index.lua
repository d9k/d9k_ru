local conf = require 'conf.conf'

local debug_mode = true
local breakpoints = conf.debug.breakpoints and debug_mode
if breakpoints then require('mobdebug').start('127.0.0.1') end

local sailor = require 'sailor'
local log_from_config = require 'log_from_config'
local redis_adapter = require 'local_libs.redis_adapter'

--require 'monkey_patching.sailor_page'
require 'override_modules.override_map'
--require 'monkey_patching.sailor_db_luasql_common'
require 'monkey_patching.sailor'

--sailor.log:info('log created')

-- will be restored in any file if you call `local sailor = require 'sailor'`
sailor.log = log_from_config.log_from_config(conf.log)
sailor.redis = redis_adapter(conf.redis)


sailor.launch()
