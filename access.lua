-- access module can't be required before request init
-- so this module is used to require 'sailor.access' and setup it's settings
local conf = require 'conf.conf'

local access = require 'sailor.access'
access.settings(conf['access_module'])
return access