local conf = require 'conf/conf'
local table_helpers = require 'table_helpers'

local M = {}

M.DEFAULT_LOGGER_PARAMS = {
  max_log_level = 'trace'
}

-- from log.lua BEGIN
local LOG_LVL = {
  EMERG     = 1;
  ALERT     = 2;
  FATAL     = 3;
  ERROR     = 4;
  WARNING   = 5;
  NOTICE    = 6;
  INFO      = 7;
  DEBUG     = 8;
  TRACE     = 9;
}

-- TODO see log.lua

local writer_names = {}
local LOG_LVL_NAMES = {}
for k,v in pairs(LOG_LVL) do
  LOG_LVL_NAMES[v] = k
  writer_names[v]  = k:lower()
end
-- END from log.lua

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

-- creates an array of lua-log loggers from config
function M.loggers_from_config(log_config)
  local result = {}

  local default_params = table_helpers.merge_tables(
    {},
    M.DEFAULT_LOGGER_PARAMS,
    log_config['default']
  )

  log_config['default'] = nil

  for loggerName, loggerConfigParams in pairs(conf.loggers) do
    local loggerParams = table_helpers.merge_tables({}, default_params, loggerConfigParams)
    local loggerClass = loggerParams._class;
    loggerParams._class = nil;
    local max_log_level = loggerParams.max_log_level

    -- TODO add groups! add filters: groupsOnly, groupsExcept

    local logWriter = require loggerClass.new(loggerParams)

    result[loggerName] = {
      object = require "log".new(
        max_log_level, logWriter -- TODO formatter, logformat
      )
    }
  end -- for loggerParams

  return result
end

-- creates logger object - envelope for lua-log loggers
function M.log_factory(loggers)

  -- TODO get_log_writer, log, dump

  -- TODO for each logger:
--  max_lvl = lvl
--  for i = 1, max_lvl do logger[ writer_names[i]           ] = function(...) write(i, ...) end end
--  for i = 1, max_lvl do logger[ writer_names[i] .. '_dump'] = function(...) dump(i, ...)  end end
--  for i = max_lvl+1, LOG_LVL_COUNT  do logger[ writer_names[i]           ] = emptyfn end
--  for i = max_lvl+1, LOG_LVL_COUNT  do logger[ writer_names[i] .. '_dump'] = emptyfn end

end


return M