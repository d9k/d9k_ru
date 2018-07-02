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

  local system_name = page.GET.pk

  if not system_name then
    error('pk url param not set')
  end

  local article = Article:find_by_id(system_name)
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
      or error('global_id not set')

  local article = Article:find_by_attributes {global_id = article_global_id}
  local revisions = article:load_revisions()

  table.insert(page.breadcrumbs, {url='/admin/article_edit?pk=' .. article.system_name, caption='Article '..article.system_name})

  page:render('article/revisions', {article=article, revisions=revisions})
end

M.article_restore_revision = function(page)
  local Article = sailor.model('article')

--  local article_global_id = page.GET.article_global_id
--      or error('article_global_id not set')

  local revision_file_path = page.GET.revision_file_path
      or error('revision_file_path not set')

  local article = Article:new()

--  article.revision = revision_global_id

  -- see model_backup_mixin
--  local backup_file_path = article:get_backup_file_path_with_revision()

  -- TODO secure!
  article:set_attrs_from_file(revision_file_path)

  local existing_article = article:find_by_attributes {global_id = article.global_id}

  if existing_article then
    existing_article:set_attrs_from_file(revision_file_path)
    article = existing_article
  end

  article:save()

  page:redirect('/admin/article_revisions?global_id=' .. article.global_id)
end

return M
