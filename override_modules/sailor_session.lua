--------------------------------------------------------------------------------
-- session.lua, v0.2.1: cgilua session abstraction
-- This file is a part of Sailor project
-- Copyright (c) 2014 Etiene Dalcol <dalcol@etiene.net>
-- License: MIT
-- http://sailorproject.org
--------------------------------------------------------------------------------

local sailor = require "sailor"
local utils = require "web_utils.utils"
local session = require "web_utils.session"
local cookie = require "sailor.cookie"

local ID_NAME = "SAILORSESSID"

session.id = nil

--sailor.log:info('sailor session overriden reloaded')

local sailor_init_complete = false

session.after_sailor_init = function()
  if sailor_init_complete then
    return
  end

  local conf = require 'conf.conf'

  session.setsessiondir (sailor.path..'/runtime/tmp')
  -- https://github.com/sailorproject/sailor/issues/164 temporary fix

  if conf.access_module and conf.access_module.grant_time then
    session.setsessiontimeout(conf.access_module.grant_time)
  end
  sailor_init_complete = true
end



function session.open (r)
  session.after_sailor_init()
--  local log = function(s)
--    sailor.log:info('session.open: ' .. s)
--  end

--  log('start')
  local inspect = require 'inspect'

--  log('session id: ' .. inspect(session.id))

	if session.id then
		return session.id
	end

	local id = cookie.get(r, ID_NAME)
--  log('id after cookie get: ' .. (id or ''))
    if not id then
        session.new(r)
    else
        session.data = session.load(id)
        if session.data then
        	session.id = id
        else
            session.new(r)
        end
    end

	session.cleanup()
--  log('end '..session.id)
  -- bug! there was:
  -- return id
	return session.id
end

function session.destroy (r)
  session.after_sailor_init()

	local id = session.id or cookie.get(r,ID_NAME )
	if id then
		session.data = {}
		session.delete (id)
	end
	session.id = nil
	return true
end

local new = session.new
function session.new(r)
  session.after_sailor_init()

	session.id = new()
	session.data = {}
    cookie.set(r,ID_NAME,session.id)
end

local save = session.save
function session.save(data)
--  sailor.log:info('session.save to '..session.id)
  session.after_sailor_init()

	save(session.id,data)
	session.data = data
	return true
end

function session.is_active()
	return session.id ~= nil
end


return session
