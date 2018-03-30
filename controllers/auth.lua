local access = require 'access'

--local conf = require 'conf.conf'
--local access = require 'sailor.access'
--access.settings(conf['access_module'])

local auth = {}

function auth.login(page)

  local login = page.POST.login or ''
  local password = page.POST.password or ''

  local auth_ok , auth_err

  if page.POST.submit then
    auth_ok, auth_err = access.login(login, password)
  end

  page:render('login', {login = login, auth_ok = auth_ok, auth_err = auth_err})
end

return auth