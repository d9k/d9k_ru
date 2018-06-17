local sailor = require 'sailor'

local not_found = {}

not_found.not_found = function(page, route_name)
  local Article = sailor.model('article')

  local article = Article:find_by_attributes({
    url_alias = route_name
  })

  if article then
    return page:render('article/view', {article=article})
  end

  page:render('error/404', {route_name = route_name})
end


return not_found