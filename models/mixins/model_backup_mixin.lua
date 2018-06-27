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

-- @param table Model:
--    Model.model_name required
--    Model.get_model() required
--
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

  Model.load_data_from_file = function (lua_file_path)
--    _ENV = {} -- run loaded code in safe environment
    return dofile(lua_file_path)
  end

  Model.set_attrs_from_data = function (self, data)
    -- TODO fix data due to applied migrations differences
    for _,n in pairs(self.attributes) do
      for attr,_ in pairs(n) do
        self[attr] = data[attr]
      end
    end
  end

  Model.set_attrs_from_file = function (self, lua_file_path)
    local data = Model.load_data_from_file(lua_file_path)
    self:set_attrs_from_data(data)
  end

  Model.load_revisions = function(self)
    local ModelClass = Model.get_model()
    local result = {}
    local revisions_files = penlight_dir.getfiles(self:get_backup_folder_revisions_path(), '*.lua')
    for _, file_path in pairs(revisions_files) do
      local model = ModelClass:new()
      model:set_attrs_from_file(file_path)
      result[file_path] = model
    end
    return result
  end

end

return M