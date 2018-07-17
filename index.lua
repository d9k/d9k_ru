local conf = require 'conf.conf'

local debug_mode = true
local breakpoints = conf.debug.breakpoints and debug_mode
if breakpoints then require('mobdebug').start('127.0.0.1') end

local sailor = require 'sailor'
local log_from_config = require 'log_from_config'
local redis_adapter = require 'local_libs.redis_adapter'

--require 'monkey_patching.sailor_page'

--require 'monkey_patching.sailor_db_luasql_common'
require 'monkey_patching.sailor'

--sailor.log:info('log created')

-- will be restored in any file if you call `local sailor = require 'sailor'`
sailor.log = log_from_config.log_from_config(conf.log)
sailor.redis = redis_adapter(conf.redis)

sailor.before_launch = function ()
--  sailor.log:info('before launch')

  -- models variables are cached by xavante
  -- reset due to fields in modules cache
  package.loaded['sailor.access'] = nil
  package.loaded['sailor.session'] = nil
  package.loaded['override_modules.sailor_session'] = nil
  package.loaded['web_utils.session'] = nil
  package.loaded['override_modules.override_map'] = nil

  require 'override_modules.override_map'
end

sailor.after_init = function ()
--  sailor.log:info('after init')

  local access = require 'sailor.access'
  access.settings(conf['access_module'])
end

sailor.launch()
