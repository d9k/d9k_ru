local conf = require 'conf.conf'
local sailor = require 'sailor'

local not_found = {}

not_found.not_found = function(page, route_name)
  local route = page.GET[conf.sailor.route_parameter_nonparsed]

  local Article = sailor.model('article')

  local article = Article.find_by_attributes({
    url_alias = route
  })

  if article then
    return page:render('article/view', {article=article})
  end

  page:render('error/404', {route_name = route})
end


return not_found