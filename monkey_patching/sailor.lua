local sailor = require 'sailor'
local conf = require 'conf.conf'
local match, traceback,xpcall = string.match, debug.traceback,xpcall
local remy = require "remy"

-- MOD: breaking compatibility with apache
local httpd = remy.httpd

-- Auxiliary function to open the autogen page for models and CRUDs
-- page: our page object
local function autogen(page)
    local autogen = require "sailor.autogen"

    local src = autogen.gen()
    src = lp.translate(src)
    page:render('sailor/autogen',{page=page},src)
end

-- Gets parameter from url query and made by mod rewrite and reassembles into page.GET
-- TODO - improve
--local function apache_friendly_url(page)
--    if conf.sailor.friendly_urls and page.GET.q and page.GET.q ~= '' then
--        local query = {}
--        for w in string.gmatch(page.GET.q, "[^/]+") do
--            table.insert(query,w)
--        end
--        for i=1,#query,2 do
--            if query[i+1] then
--                page.GET[query[i]] = query[i+1]
--            end
--        end
--    end
--end

-- Reads route GET var to decide which controller/action or default page to run.
-- page: Page object with utilitary functions and request
function sailor.route(page)
    local error_404, error_handler

    local require_lua_file = function (dotted_path)
      local status, err_or_result = pcall(function() return require(dotted_path) end)
      if status then
        local result = err_or_result
        return result
      else
        local _error = err_or_result
        return status, _error
      end
    end

    -- breaking compatibility with apache
--    apache_friendly_url(page)

    local route_name = page.GET[conf.sailor.route_parameter]

    -- mod BEGIN
--    local theme_folder = page:get_theme_folder()
    local theme_callbacks_dotted_path = 'themes.' .. page.theme .. '.callbacks'
    local theme_callbacks, callbacks_load_error = require_lua_file(theme_callbacks_dotted_path)

    if theme_callbacks then
      if theme_callbacks.before_controller then
        theme_callbacks.before_controller(page)
      end
    else
      if not callbacks_load_error:match[[module '[%a%d%._-]+' not found]] then
        error(callbacks_load_error)
      end
    end

    -- END mod

    page.breadcrumbs = {}

    -- Error for controller or action not found
    error_404 = function()
        local _, res
        if sailor.conf.default_error404 and sailor.conf.default_error404 ~= '' then
            page.controller_view_path = nil
            _, res = xpcall(function () page:render(sailor.conf.default_error404) end, error_handler)
            return res or httpd.OK or page.r.status or 404
        end
        page.r.status = 404
        return res or page.r.status
    end
    -- Encapsulated error function for showing detailed traceback
    -- Needs improvement
    error_handler = function (msg)
        if sailor.conf.hide_stack_trace then
            page:write("<pre>Error 500: Internal Server Error</pre>")
            return 500
        end
        page:write("<pre>"..traceback(msg,2).."</pre>")
    end

    -- If a default static page is configured, run it and prevent routing
    if conf.sailor.default_static then
        xpcall(function () page:render(conf.sailor.default_static) end, error_handler)
        return httpd.OK or page.r.status or 200
    -- If there is a route path, find the correspondent controller/action
    else
        local controller, action

        local require_controller = function(controller_name)
    --          local status, err_or_result = pcall(function() return require("controllers."..controller) end)
    --          if status then
    --            local result = err_or_result
    --            return result
    --          else
    --            local _error = err_or_result
    --            return status, _error
    --          end
          return require_lua_file('controllers.' .. controller)
        end

        if not route_name or route_name == '' then
            controller, action = conf.sailor.default_controller, conf.sailor.default_action
        else
            controller, action = match(route_name, "([^/]+)/?([^/]*)")
        end

        if controller == "autogen" then
            if conf.sailor.enable_autogen then
                local _,res = xpcall(function () autogen(page) end, error_handler)
                return res or httpd.OK or page.r.status or 200
            end
            return error_404()
        end

        local controller_not_found = false
        local ctr, controller_load_error = require_controller(controller)

        if not ctr then
          if controller_load_error:match[[module '[%a%d%._-]+' not found]] then
            controller = 'not_found'
            ctr = require_controller(controller)
            controller_not_found = true
          else
            error(controller_load_error)
          end
        end

        if not ctr then
          return error_404()
        end

        local _, res

--        local _, res = xpcall(function() ctr = require("controllers."..controller) end, error_handler)
        if ctr then
            local before_passed = true
            if ctr.before then
              -- optional "before" must return true
              _, before_passed = xpcall(function() return ctr.before(page) end, error_handler)
            end
            if before_passed then
              if controller_not_found then
                page.controller_view_path = 'views/'
                _, res = xpcall(function() return ctr.not_found(page, route_name) end, error_handler)
              else
                local custom_path = ctr.path or (ctr.conf and ctr.conf.path)
                page.controller_view_path = (custom_path and custom_path..'/views/'..controller) or 'views/'..controller
                -- if no action is specified, defaults to index
                if action == '' then
                    action = 'index'
                end

  --            if not ctr[action] then return error_404() end

  --            -- run action
  --            _, res = xpcall(function() return ctr[action](page) end, error_handler)
  --              _, res = xpcall(function() return ctr(page, route_name) end, error_handler)
  --            else
                if ctr[action] then

                  -- run action
                  _, res = xpcall(function() return ctr[action](page) end, error_handler)
                elseif ctr.not_found then
                  _, res = xpcall(function() return ctr.not_found(page, action) end, error_handler)
                else
                  return error_404()
                end
              end -- before passed
            end -- controller found
            if res == 404 then return error_404() end
        end -- if ctr

        return res or httpd.OK or page.r.status or 200
    end
end

function sailor.launch(native_request)
--    print('on sailor_launch')
--    local inspect = require 'inspect'
--    print('on sailor_launch: sailor.access: ' .. inspect(package.loaded['sailor.access']))
--    package.loaded['sailor.access'] = nil

    print('overriden sailor launch')

    if sailor.before_launch then
      sailor.before_launch()
    end

    if apr_table ~= nil then
        -- This is Apache with mod_lua
        -- Sets a handle function to be called by mod_lua
        httpd = apache2
        handle = sailor.handle_request
    else
        -- This is a non-Apache (such as Nginx, Lighttpd, etc) or
        -- Apache with CGILua or mod_pLua
        -- Handled by Remy extension
        httpd = remy.httpd
        sailor.remy_mode = remy.init(sailor.remy_mode, native_request)
        remy.contentheader('text/html')
        remy.run(sailor.handle_request)
    end
end


function sailor.handle_request(r)
    r.content_type = "text/html"
    local page = sailor.init(r)
    if sailor.after_init then
      sailor.after_init()
    end
    return sailor.route(page)
end