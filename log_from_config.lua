local conf = require 'conf/conf'
local table_helpers = require 'table_helpers'

local M = {}

M.DEFAULT_LOGGER_PARAMS = {
  max_log_level = 'trace'
}

-- see https://github.com/moteus/lua-log
--local LOG = require "log".new(
--  -- maximum log level
--  "trace",

--  -- Writer
--  require 'log.writer.list'.new(               -- multi writers:
--    require 'log.writer.console.color'.new(),  -- * console color
----    require 'log.writer.file.roll'.new(        -- * roll files
----      './logs',                                --   log dir
----      'events.log',                            --   current log name
----      10,                                      --   count files
----      10*1024*1024                             --   max file size in bytes
----    )
--    require 'log.writer.file'.new{        -- * roll files
--      log_dir = './runtime/logs',                                --   log dir
--      log_name = 'events.log',                            --   current log name
--      flush_interval = 0,
--      close_file = true,
--      reuse = true
--    }
--  ),

--  -- Formatter
--  require "log.formatter.concat".new()
--)

-- conf.loggers

function M.loggers_from_config(log_config)
  local loggers = {}

  local default_params = table_helpers(
    {},
    M.DEFAULT_LOGGER_PARAMS
    log_config['default']
  )

  log_config['default'] = nil

  -- TODO
  for loggerName, loggerParams in pairs(conf.loggers) do

  end -- for loggerParams

  return loggers
end

function M.log_factory(loggers)


end


return M