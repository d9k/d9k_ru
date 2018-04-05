local table_helpers = require 'helpers.table'
--local pprint = require 'thirdparty_libs/pprint'.pprint

--local sailor_db_config_key = 'development'

local M = {}

function M.db_config_from_sailor_config(sailor_config, sailor_db_config_key)
  local db_config = table_helpers.merge_tables(sailor_config['db'][sailor_db_config_key])

  db_config = table_helpers.table_move_keys(db_config, {
    db_name = 'dbname',
    adapter = 'driver',
    password = 'pass'
  })

  if db_config['adapter'] == 'postgres' then
    db_config['adapter'] = 'postgresql'
  end

  return db_config
end

return M
