luasql_common = require 'sailor.db.luasql_common'
local conf = require 'conf.conf'

-- adding port param to luasql_common.connect
local db_conf = conf.db[conf.sailor.environment]
local luasql = require("luasql."..db_conf.driver)

luasql_common.connect = function ()
	if luasql_common.transaction then return end
	luasql_common.env = assert (luasql[db_conf.driver]())
	luasql_common.con = assert (luasql_common.env:connect(db_conf.dbname, db_conf.user, db_conf.pass, db_conf.host, db_conf.port))
end