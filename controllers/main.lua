local conf = require "conf.conf"

local sailor = require 'sailor'
local access = require 'sailor.access'

local main = {}

function main.index(page)
  local Article = sailor.model('article')

  local article = Article:find_by_attributes({
    url_alias = 'index'
  })

  if article then
    local article_controller = require 'controllers.article'
    return article_controller._render(page, article)
  end

  page:render('index')
end

function main.action2(page)
  page:render('action2')
end

return main
