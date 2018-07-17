local pformat = require 'thirdparty_libs.pprint'.pformat

--local conf = require 'conf.conf'
--local access = require 'sailor.access'
--access.settings(conf['access_module'])

local auth = {}

function auth.login(page)
  -- modules are not reloaded so reload again in action
  local access = require 'sailor.access'
  local session = require 'sailor.session'

  local login = page.POST.login or ''
  local password = page.POST.password or ''

  local auth_ok , auth_err

  if page.POST.submit then
    auth_ok, auth_err = access.login(login, password)
  end

  local session_data = session.data

  page:render('login', {
    login = login,
    auth_ok = auth_ok,
    auth_err = auth_err,
    session_data_text = pformat(session_data)
  })
end

function auth.logout(page)
  local access = require 'sailor.access'
  local session = require 'sailor.session'
  access.logout()

  page:render('login', {logout = true, session_data = session_data})
end

return auth