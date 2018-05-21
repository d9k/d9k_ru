local conf = require "conf.conf"

local sailor = require 'sailor'
local access = require 'sailor.access'

local main = {}

function main.index(page)

  page:render('index')
end

function main.action2(page)
  page:render('action2')
end

return main
