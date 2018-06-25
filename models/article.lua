local sailor = require 'sailor'
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
    { create_time = 'safe' },
    { modify_time = 'safe' },
    { revision = 'safe' },
    { global_id = 'safe' },
    -- TODO implement uuid validation!
    -- global_id uuid DEFAULT public.uuid_generate_v4() NOT NULL
  },
  db = {
    key = 'id',
    table = 'article',
  },

  boolean_fields = {'active'},
  string_fields = {'system_name'},
  revision_changed_fields = {'name', 'system_name', 'content', 'url_alias', 'content_type'}
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

article.get_model = function()
  return sailor.model('article')
end

-- TODO to sailor.model to run automatically (?)
article.before_update = function(self)
  local ModelClass = article.get_model()
  local model_in_db = ModelClass:find_by_id(self.id)

  self.modify_time = {value='DEFAULT', _type='raw_sql'}
  -- TODO save modified_by

  local new_revision = false
  for _, attr_name in pairs(article.revision_changed_fields) do
    if model_in_db[attr_name] ~= self[attr_name] then
      new_revision = true
      break
    end
  end

  if new_revision then
    self.revision = {value='DEFAULT', _type='raw_sql'}
  end
end

article.after_save = function(self)
  local ModelClass = article.get_model()
  local updated_model = ModelClass:find_by_id(self.id)
  -- TODO loop by attributes
  self.revision = updated_model.revision
  self.modify_time = updated_model.modify_time
  -- TODO save to file
end

article.get_backup_file_name = function(self)
  return self.global_id .. '_' .. self.name
end

article.get_backup_file_name_with_revision = function(self)
  return self.global_id .. '_' .. self.name .. '_' .. self.revision
end

article.save_to_file = function (self, file_name)
--  self.attributes
end

article.load_from_file = function (self, file_name)
--  article.attributes
end

return article