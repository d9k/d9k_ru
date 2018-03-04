local main = {}

local conf = require "conf.conf"
local debug = false
local breakpoints = conf.debug.breakpoints and debug
local pprint = require "thirdparty_libs.pprint".pformat

local sailor = require 'sailor'

-- see https://github.com/moteus/lua-log
local LOG = require "log".new(
  -- maximum log level
  "trace",

  -- Writer
  require 'log.writer.list'.new(               -- multi writers:
    require 'log.writer.console.color'.new(),  -- * console color
--    require 'log.writer.file.roll'.new(        -- * roll files
--      './logs',                                --   log dir
--      'events.log',                            --   current log name
--      10,                                      --   count files
--      10*1024*1024                             --   max file size in bytes
--    )
    require 'log.writer.file'.new{        -- * roll files
      log_dir = './runtime/logs',                                --   log dir
      log_name = 'events.log',                            --   current log name
      flush_interval = 0,
      close_file = true,
      reuse = true
    }
  ),

  -- Formatter
  require "log.formatter.concat".new()
)


function main.index(page)

    LOG.info("some", "info")
    LOG.info("t = " .. pprint({test = {table = 1}}))
    LOG.info("sailor.test = " .. sailor.test)
    LOG.error("must be red")

    if breakpoints then
        require('mobdebug').start('127.0.0.1')
    end
    page:render('index')
end

return main
