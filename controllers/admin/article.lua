local sailor = require 'sailor'
--local pretty_format = require 'inspect'

local M = {}

local breadcrumbs_add_articles = function(page)
  table.insert(page.breadcrumbs, {url='/admin/article', caption='Articles'})
end

M.article = function(page)
  breadcrumbs_add_articles(page)

  local Article = sailor.model('article')

  local articles = Article:find_all()

  page:render('article/index', {articles=articles})
end

M.article_edit = function(page)
  breadcrumbs_add_articles(page)

  local Article = sailor.model('article')

  local article_id = page.GET.id

  if not article_id then
    error('article_id not set')
  end

  local article = Article:find_by_id(article_id)
  local ers

  article:fix_data()

  if next(page.POST) then
    article:from_post(page.POST)

--    article:before_update()

    if not article:save() then
      ers = article.errors
    end

--    article:after_update()
  end

  page:render('article/edit', {article=article})
end

M.article_new = function(page)
  breadcrumbs_add_articles(page)

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

M.article_revisions = function (page)
  breadcrumbs_add_articles(page)

  local Article = sailor.model('article')

  local article_global_id = page.GET.global_id

  if not article_global_id then
    error('global_id not set')
  end

  local article = Article:find_by_attributes {global_id = article_global_id}
  local revisions = article:load_revisions()

  table.insert(page.breadcrumbs, {url='/admin/article_edit?id=' .. article.id, caption='Article #'..article.id})

  page:render('article/revisions', {article=article, revisions=revisions})
end

return M
