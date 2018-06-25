local sailor = require 'sailor'
local valua = require 'valua'
local table_helpers = require 'helpers.table'
local pretty_format = require 'inspect'
local files_helpers = require 'helpers.files'

local penlight_path = require 'pl.path'
local penlight_dir = require 'pl.dir'

local guid_sub = function(guid, length)
  length = length or 10
  local g = guid:gsub('%-', '')
  return g:sub(1, length)
end

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
  revision_changed_fields = {'name', 'system_name', 'content', 'url_alias', 'content_type'},
  model_name = 'article'
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
  return sailor.model(article.model_name)
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

  self:save_backups()
end

article.save_backups = function(self)
  penlight_dir.makepath(self:get_backup_folder_path())
  self:save_to_file(self:get_backup_file_path())
  penlight_dir.makepath(self:get_backup_folder_revisions_path())
  self:save_to_file(self:get_backup_file_path_with_revision())
end

-- backup functionality to mixin class

article.get_backup_folder_path = function(self)
  return 'runtime/backup_models/' .. article.model_name
end

article.get_backup_folder_revisions_path = function(self)
  return self:get_backup_folder_path() .. '/' .. self.global_id
end

article.get_backup_file_path = function(self)
  return self:get_backup_folder_path() .. '/'
      .. self.model_name .. '__' .. guid_sub(self.global_id) .. '__' .. self.system_name .. '.lua'
end

article.get_backup_file_path_with_revision = function(self)
  return self:get_backup_folder_revisions_path() .. '/'
      .. self.model_name .. '__' .. guid_sub(self.global_id) .. '__' .. self.system_name .. '__' .. guid_sub(self.revision) .. '.lua'
end

article.save_to_file = function (self, file_name)
  local data = {}

  for _,n in pairs(self.attributes) do
		for attr,_ in pairs(n) do
      data[attr] = self[attr]
    end
  end

  local data_lua_code = 'return ' .. pretty_format(data)

  files_helpers.file_put_contents(file_name, data_lua_code)
end

article.load_from_file = function (self, file_name)
--  TODO run lua file in save environment!
end

return article