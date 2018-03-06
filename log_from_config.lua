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
  local log_config_copy = table_helpers.merge_tables({}, log_config)

  local default_params = table_helpers.merge_tables(
    {},
    M.DEFAULT_LOGGER_PARAMS,
    log_config['default']
  )

  log_config_copy['default'] = nil

  for logger_name, logger_config_params in pairs(log_config_copy) do
    local logger_params = table_helpers.merge_tables({}, default_params, logger_config_params)
    local logger_class_name = logger_params._class;
    logger_params._class = nil;
    local max_log_level = logger_params.max_log_level
    logger_params.max_log_level = nil

    -- TODO add groups! add filters: groupsOnly, groupsExcept

    local logger_class = require(logger_class_name)
    local log_writer = logger_class.new(logger_params)

    result[logger_name] = {
      object = require "log".new(
        max_log_level, log_writer -- TODO formatter, logformat
      )
    }
  end -- for logger_params

  return result
end

-- creates logger object - envelope for lua-log loggers
function M.log_factory(loggers)

  local log = {loggers = loggers}

  function log:get_logger(log_writer_name)
    return self.loggers[log_writer_name]['object']
  end

  local writer_dump_names = {}
  for _, writer_name in ipairs(writer_names) do
    table.insert(writer_dump_names, writer_name .. '_dump')
  end

  local methods_names = table_helpers.append_arrays({}, writer_names, writer_dump_names, {'log', 'dump'})

  -- TODO implement categories! (logger.categories_only, logger.catergories_except)

  for _, method_name in pairs(methods_names) do
    log[method_name] = function(self, ...)
--    log[method_name] = function(...)
      for logger_name, _ in pairs(self.loggers) do
        local logger = self:get_logger(logger_name)
        logger[method_name](...)
      end
    end -- function name
  end -- for method name

-- how it was at log.lua:
--
--  max_lvl = lvl
--  for i = 1, max_lvl do logger[ writer_names[i]           ] = function(...) write(i, ...) end end
--  for i = 1, max_lvl do logger[ writer_names[i] .. '_dump'] = function(...) dump(i, ...)  end end
--  for i = max_lvl+1, LOG_LVL_COUNT  do logger[ writer_names[i]           ] = emptyfn end
--  for i = max_lvl+1, LOG_LVL_COUNT  do logger[ writer_names[i] .. '_dump'] = emptyfn end

  return log
end -- M.log_factory

function M.log_from_config(log_config)
  local loggers = M.loggers_from_config(log_config)
  return M.log_factory(loggers)
end


return M