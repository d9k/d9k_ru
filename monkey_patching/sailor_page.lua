-- TODO WRONG, not used, delete!
-- re-merge on sailor update!

local page = require 'sailor.page'
local html_helpers = require 'helpers.html'
local sailor = require 'sailor'

sailor.log:info("monkey patchin'")

local function render_page_override(path,parms,src)
  sailor.log:info("at render_page_override")

  -- mod BEGIN
  for k, v in pairs(html_helpers) do
      parms[k] = v
  end
  -- END mod

  for k, v in pairs(_G) do
      parms[k] = v
  end

  local f
  if _VERSION == "Lua 5.1" then
      f = assert(loadstring(src,'@'..path))
      setfenv(f,parms)
  else
      f = assert(load(src,'@'..path,'t',parms))
  end

  f()
end

-- Includes a .lp file from a .lp file
-- path: string, full file path
-- parms: table, vars being passed ahead
page.include = function (self, path, parms)
    parms = parms or {}

    local incl_src = read_src(sailor.path..'/'..path)
    incl_src = lp.translate(incl_src)
    parms.page = self
    render_page_override(path,parms,incl_src)
end

-- Renders a view from a controller action
-- filename: string, filename without ".lp". The file must be inside /views/<controller name>
-- parms: table, vars being passed ahead.
page.render = function(self, filename,parms,src)
    parms = parms or {}
    if src ~= nil then return render_page_override(filename,parms,src) end -- shortcut for autogen module

    local filepath

    -- If there's a default theme, parse the theme first
    if self.theme ~= nil and self.theme ~= '' then
        self.theme_path = self.base_path.."/themes/"..self.theme
        filepath = ((sailor.path):match('(.*)'..self.base_path:gsub('-','%%-') ) or '')..self.theme_path.."/"..self.layout

        local theme_src = read_src(filepath)
        local filename_var = "sailor_filename_"..tostring(random(1000))
        local parms_var = "sailor_parms_"..tostring(random(1000))
        -- Then remove theme and continue parsing
        src = gsub(theme_src,"{{content}}",' <? page.theme = nil; page:render('..filename_var..','..parms_var..') ?> ')
        parms[filename_var] = filename
        parms[parms_var] = parms

    else
        local dir = self.controller_view_path or 'views'
        -- filename is nil if the controller script is missing in /controllers/
        if filename ~= nil then
            filepath = sailor.path..'/'..dir..'/'..filename
            src = read_src(filepath)
        else
            error("No view name available.")
            return
        end

    end

    if conf.debug and conf.debug.inspect and ( (conf.sailor.theme and self.theme) or not conf.sailor.theme )then
        local debug_src = read_src(sailor.path.."/views/error/inspect")
        src = src..debug_src
    end

    if filename ~= nil then
        src = lp.translate(src)
        parms.page = self
        render_page_override(filepath..".lp",parms,src)
    end
end

page.to_browser = function(self, var_table)
    if conf.lua_at_client.vm ~= "starlight" then
        error("page:to_browser is not yet supported by the current Lua->JS virtual machine. Please switch to Starlight if you need this feature.")
    end
    local vm = require("latclient.starlight")

    local code = {}
    for name, var in pairs(var_table) do
        table.insert(code, " "..name.." = "..to_string(var))
    end
    code = table.concat(code,"\n")
    local client_code = vm.get_client_js(code)
    render_page_override('',{},lp.translate(client_code,true))
end

page.patched = true