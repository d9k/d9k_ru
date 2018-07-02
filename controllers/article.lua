local sailor = require 'sailor'
local Article = sailor.model('article')

local M = {}

M._render = function(page, article)
  article:fix_data()

  if not article.active then
    error('article not found or hidden')
  end

  page.controller_view_path = 'views/'
  page:render('article/view', {article=article})
end

-- no set actions in this controller. article system name is mapped as action
M.not_found = function (page, action)
  local article_system_name = action

  local article = Article:find_by_attributes({
    system_name = article_system_name
  })

  if not article then
    -- TODO 404
    error('article with system name "' .. article_system_name .. '" not found')
  end

  M._render(page, article)
end

return M