local sailor = require 'sailor'

local M = {}

M.article = function(page)
  local Article = sailor.model('article')

  local articles = Article:find_all()

  page:render('article/index', {articles=articles})
end

M.article_edit = function(page)
  local Article = sailor.model('article')

  local article_id = page.GET.id

  if not article_id then
    error('article_id not set')
  end

  local article = Article:find_by_id(article_id)

  article:fix_data()

  if next(page.POST) then
    article:from_post(page.POST)

    if not article:save() then
--      local ers = article.errors
    end
  end

  page:render('article/edit', {article=article})
end

return M
