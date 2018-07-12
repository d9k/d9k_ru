local redis = require 'redis'
local table_helpers = require 'helpers.table'

return function(redis_conf)
  local REDIS_CONF_DEFAULT = {
    host = '127.0.0.1',
    port = 6379,
    password = nil,
    db = nil
  }

  redis_conf = table_helpers.merge(REDIS_CONF_DEFAULT, redis_conf);

  local redis_client = redis.connect(redis_conf.host, redis_conf.port)
  -- local client = redis.connect('unix:///tmp/redis.sock')

  if redis_conf.password then
    redis_client:auth(redis_conf.password)
  end

  if redis_conf.db then
    redis_client:select(redis_conf.db)
  end

  return redis_client
end