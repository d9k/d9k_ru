local table_helpers = require 'helpers.table'
local sailor_helpers = require 'helpers.sailor'

local admin = table_helpers.merge(
  require 'controllers.admin.article'
)

-- runs before every admin action
admin.before = function(page)
  local user = sailor_helpers.get_user()
  if user == nil then
    page.r.status = 401
    page.controller_view_path = 'views/'
    page:render('error/unauthorised')
    return false
  end

  page.breadcrumbs = {{url='/admin', caption='Admin'}}

  return true
end

admin.index = function(page)
  page:render('index')
end

return admin