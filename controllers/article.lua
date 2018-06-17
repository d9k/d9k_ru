local sailor = require 'sailor'
local Article = sailor.model('article')

local article = {}

article.not_found = function (page, action)
  local article_system_name = action

  local article = Article:find_by_attributes({
    system_name = article_system_name
  })

  if not article then
    -- TODO 404
    error('article with system name "' .. article_system_name .. '" not found')
  end

  page:render('view', {article=article})
end

return article