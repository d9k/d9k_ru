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

  local string_to_bool = function (value)
    if type(value) == 'string' then
      if value:sub(1, 1) == 't' then
        return true
      else
        return false
      end
    end
    return value
  end

  local article_bool_attrs = {'active', 'published'}

  local article_fix_data = function ()
    for _, attr in pairs(article_bool_attrs) do
      article[attr] = string_to_bool(article[attr])
    end
  end

  local post_fix_data = function ()
    for _, attr in pairs(article_bool_attrs) do
      local post_key = 'article:' .. attr

      if page.POST[post_key] == 'on' then
        page.POST[post_key] = true
      elseif page.POST[post_key] == nil then
        page.POST[post_key] = false
      end
    end
  end

  article_fix_data()

  if next(page.POST) then
    post_fix_data()

    article:get_post(page.POST)
    article_fix_data()

    if not article:save() then
--      local ers = article.errors
    end
  end

  page:render('article/edit', {article=article})
end

return M
