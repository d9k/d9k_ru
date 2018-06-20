local valua = require 'valua'
local table_helpers = require 'helpers.table'

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

local article = {
  attributes = {
    -- implement .optional() !!!
    { id = valua:new().number().optional() },
    { name = 'safe' },
    -- TODO implement pattern validation! a-zA-Z0-9\-_ are allowed for this case
    { system_name = valua:new().match("^[%d%l_-]+$").not_empty() },
    { url_alias = 'safe' },
    { content_type = valua:new().in_list({'html', 'html+markdown'}) },
    { content = 'safe' },
--    { active = valua:new().boolean() },
--    { active = valua:new().in_list({0, 1}) },
    { active = 'safe' },
    -- TODO implement uuid validation!
    -- global_id uuid DEFAULT public.uuid_generate_v4() NOT NULL
  },
  db = {
    key = 'id',
    table = 'article',
  },

  boolean_fields = {'active'},
  string_fields = {'system_name'},
}

article.fix_data = function(self)
  for _, attr in pairs(self.boolean_fields) do
    self[attr] = string_to_bool(self[attr])
  end
  for _, attr in pairs(self.string_fields) do
    self[attr] = tostring(self[attr])
  end
end

article.from_post = function(self, post)
--  post = table_helpers.clone(post)

  for _, attr in pairs(article.boolean_fields) do
    local post_key = 'article:' .. attr

    if post[post_key] == 'on' then
      post[post_key] = true
    elseif post[post_key] == nil then
      post[post_key] = false
    end
  end

  self:get_post(post)
  self:fix_data()
end

return article