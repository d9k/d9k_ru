local redis = require 'redis'

local conf = require 'conf'
local sailor = require 'sailor'

local host = conf.redis.host or 127.0.0.1
local port = conf.redis.port or 6379
local password = conf.redis.password
local db = conf.redis.db

local redis_client = redis.connect(host, port)
-- local client = redis.connect('unix:///tmp/redis.sock')
redis_client:auth(parameters.password)

--client:select(db)