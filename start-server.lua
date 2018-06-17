local xavante = require "xavante"
local filehandler = require "xavante.filehandler"
local cgiluahandler = require "xavante.cgiluahandler"
local redirect = require "xavante.redirecthandler"
local conf = (require "conf.conf").sailor

-- Define here where Xavante HTTP documents scripts are located
local webDir = "."

local uri_map

server_port = 8083

--local debug_mode = true

if conf.friendly_urls then
    uri_map = { -- URI remapping
        match = "^[^%./]*/?([^%.]*)$",
        with = redirect,
        params = {
            "/",
            function (req, _res, cap)
                if debug_mode then require('mobdebug').start('127.0.0.1') end

                local vars = {}

                for var in string.gmatch(cap[1], '([^/]+)') do
                    table.insert(vars,var)
                end

                if #vars > 0 then
                    local mod = (#vars % 2) - 1
                    local get = ""

                    if #vars > 1 - mod then
                        for i = 2 - mod, #vars, 2 do
                            get = get.."&"..vars[i].."="..vars[i+1]
                        end
                    end

                    if mod == -1 then
                        get = vars[2]..get
                    end

--                    req.cmd_url = "/index.lua?"..conf.route_parameter.."="..vars[1].."/"..get
                    req.cmd_url = "/index.lua?"
                        ..conf.route_parameter_nonparsed.."="..cap[1]..'&'
                        ..conf.route_parameter.."="..vars[1].."/"..get

                    if req.parsed_url.query then
                      req.cmd_url = req.cmd_url .. '&' .. req.parsed_url.query
                    end
                else
                    req.cmd_url = "/index.lua"
                end

                return "reparse"
            end
        }
    }
else
    uri_map = {
        match = "^[^%./]*/$",
        with = redirect,
        params = {"index.lua"}
      }
end

local simplerules = {

    uri_map,

    { -- cgiluahandler example
      match = {"%.lp$", "%.lp/.*$", "%.lua$", "%.lua/.*$" },
      with = cgiluahandler.makeHandler (webDir)
    },

    { -- filehandler example
      match = ".",
      with = filehandler,
      params = {baseDir = webDir}
    },
}

xavante.HTTP{
    server = {host = "*", port = server_port},

    defaultHost = {
      rules = simplerules
    }
}
xavante.start()
