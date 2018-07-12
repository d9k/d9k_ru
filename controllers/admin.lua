local table_helpers = require 'helpers.table'
local sailor_helpers = require 'helpers.sailor'

local admin = table_helpers.merge(
  require 'controllers.admin.article'
)

-- runs before every admin action
admin.before = function(page)

  if sailor_helpers.render_error_if_not_logined(page) then
    return
  end

  page.breadcrumbs = {{url='/admin', caption='Admin'}}

  return true
end

admin.index = function(page)
  page:render('index')
end

return admin