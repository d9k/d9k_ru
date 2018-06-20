local sailor = require 'sailor'
--local pretty_format = require 'inspect'

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

M.article_new = function(page)
  local Article = sailor.model('article')

  local article = Article:new()
  local ers = {}

  if next(page.POST) then
    article:from_post(page.POST)

    if article:save() then
      page:redirect('/admin/article_edit?id=' .. article.id)
    else
      ers = article.errors
    end
  end

  page:render('article/edit', {article=article})
end

return M
