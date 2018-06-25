-- penlight
--local pl_path = require 'pl.path'

local table_helpers = require 'helpers.table'

local M = {}

--function M.get_script_dir()
  --local script_path = debug.getinfo(1,'S').source
  --print(script_path)
  --local script_name = pl_path.basename (script_path)
  --if string.sub(script_path, 1, 1) == '@' then
      --script_path = string.sub(script_path, 2)
  --end
  --script_path = pl_path.abspath(script_path)
  --local script_dir = pl_path.dirname(script_path)
  --return script_dir
--end

function M.file_get_contents(file_path)
  local f = io.open(file_path, "rb") -- binary read
  local content = f:read("*all")
  f:close()
  return content
end

function M.file_put_contents(file_path, new_content)
  local f = io.open(file_path, "wb") -- binary write
  --local a =
  f:write(new_content)
  f:close()
end

-- time string for file name part
function M.time_string(datetime)
  return os.date("%Y_%m_%d__%H_%M_%S", datetime)
end

function M.get_home_path()
  return os.getenv('HOME')
end

-- for example ~/temp/test_{time}.log
function M.path_from_template(path_template, replace_what_with_what)
  local to_replace = table_helpers.merge_tables(replace_what_with_what, {
    time = M.time_string()
  })

  local file_path = path_template
  file_path = file_path:gsub('~', M.get_home_path())

  for key, value in pairs(to_replace) do
    file_path = file_path:gsub('{' .. key .. '}', value)
  end

  return file_path
end

-- see also http://lua-users.org/wiki/SplitJoin
function M.split_to_lines (text)
   local t = {}
   local helper = function (line)
      table.insert(t, line)
      return ""
   end
   helper((text:gsub("(.-)\r?\n", helper)))
   return t
end

-- @see https://stackoverflow.com/questions/9676113/lua-os-execute-return-value#9676174
function M.exec(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

return M
