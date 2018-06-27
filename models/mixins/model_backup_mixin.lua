local pretty_format = require 'inspect'
local files_helpers = require 'helpers.files'
local string_helpers = require 'helpers.string'

local penlight_path = require 'pl.path'
local penlight_dir = require 'pl.dir'

local guid_sub = string_helpers.guid_sub
local sql_date_to_timestamp = string_helpers.sql_date_to_timestamp

local M = {
  BACKUP_FOLDER_PATH = 'runtime/backup_models/';
}

-- @param Model: Model.model_name required
M.mixin = function (Model)

  Model.save_backups = function(self)
    penlight_dir.makepath(self:get_backup_folder_path())
    self:save_to_file(self:get_backup_file_path())
    penlight_dir.makepath(self:get_backup_folder_revisions_path())
    self:save_to_file(self:get_backup_file_path_with_revision())
  end

  -- backup functionality to mixin class

  Model.get_backup_folder_path = function(self)
    return M.BACKUP_FOLDER_PATH .. Model.model_name
  end

  Model.get_backup_folder_revisions_path = function(self)
    return self:get_backup_folder_path() .. '/' .. self.global_id
  end

  Model.get_backup_file_path = function(self)
    return self:get_backup_folder_path() .. '/'
        .. self.model_name .. '__' .. guid_sub(self.global_id) .. '__' .. self.system_name .. '.lua'
  end

  Model.get_backup_file_path_with_revision = function(self)
    local modify_timestamp = sql_date_to_timestamp(self.modify_time)
    local modify_time_string = files_helpers.time_string(modify_timestamp)

    return self:get_backup_folder_revisions_path() .. '/'
        .. self.model_name .. '__' .. guid_sub(self.global_id, 4) .. '__'
        .. modify_time_string .. '__' .. self.system_name .. '__' .. guid_sub(self.revision, 4) .. '.lua'
  end

  Model.save_to_file = function (self, file_name)
    local data = {}

    for _,n in pairs(self.attributes) do
      for attr,_ in pairs(n) do
        data[attr] = self[attr]
      end
    end

    local data_lua_code = 'return ' .. pretty_format(data)

    files_helpers.file_put_contents(file_name, data_lua_code)
  end

  Model.load_from_file = function (self, file_name)
  --  TODO run lua file in save environment!
  end

end

return M