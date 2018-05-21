M = {}

M.get_user = function()
  local session = require 'sailor.session'

  local user = nil

  if session.data and session.data.login then
    user = {login = session.data.login}
  end

  return user
end

return M