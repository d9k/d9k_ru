local sailor_config = require 'conf/conf'
--local table_helpers = require 'helpers.table'
local pprint = require 'thirdparty_libs/pprint'.pprint
local db_tools_config_from_sailor_config = require 'config_db_tools_helpers'.db_config_from_sailor_config

local sailor_db_config_key = 'development'

local db_config = db_tools_config_from_sailor_config(sailor_config, sailor_db_config_key)

db_config.dump_name = 'db'

local db_tools_config = {
  db = db_config
}

return db_tools_config

-- debug print:
--pprint(db_tools_config)
--print('=================')
--pprint(sailor_config)
