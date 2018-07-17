-- TODO mod sailor.access

local M = {}

M.get_user = function()
--  local access = require 'sailor.access'
  local session = require 'sailor.session'

  local user = nil

  if session.data and session.data.login then
    user = {login = session.data.login}
  end

  return user
end

M.render_error_if_not_logined = function(page)
  local user = M.get_user()
  if user == nil then
    page.r.status = 401
    page.controller_view_path = 'views/'
    page:render('error/unauthorised')
    return true
  end
  return false
end

return M