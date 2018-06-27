local utf8 = require 'lua-utf8'

local M = {}

--M.empty_string_if_nil = function (text)
--  if text == nil then
--    return ''
--  end
--  return text
--end

M.empty_string_if_nil = function (...)
  local result = {}
  local args, args_count = {...}, select('#', ...)
  for i = 1, args_count do
    local item = args[i]
    if item == nil then
      table.insert(result, '')
    else
      table.insert(result, item)
    end
  end

  return unpack(result)
end

-- accepts multiple strings
-- " in strings will be replaced with ""
M.quotise = function(strings_list)
  local result = {}
  local single_value = type(strings_list) ~= 'table'

  if single_value then
    strings_list = {strings_list}
  end

  for i = 1, #strings_list do
    local s = tostring(strings_list[i])
--    local inspect = require 'inspect'
--    print(inspect(item))
    s = s:gsub([["]], [[""]])
    table.insert(result, [["]] .. s .. [["]])
  end

  if single_value then
    return result[1]
  else
    return result
  end
end

M.empty = function (s)
  return s == nil or s == '' or s == false
end

M.table_remove_empty_strings = function (t)
  local result = {}

  for k, _ in pairs(t) do
    if t[k] ~= '' then
      result[k] = t[k]
    end
  end

  return result
end

M.right_padding = function (s, desired_length_with_spaces)
    local spaces_count = math.max(desired_length_with_spaces - utf8.len(s), 0)
    return s .. string.rep(' ', spaces_count)
end

M.ask_true = function(question)
  print(question)
  io.write('> ')
  local answer = io.read()
  return answer:lower():sub(1, 1) == 'y'
end

M.ends_with = function(s, s_end)
  local end_len = utf8.len(s_end)
  local actual_end = utf8.sub(s, -end_len)
  return actual_end == s_end
end

-- example: 4e9b9dc7-d84a-4901-bbd8-0cdb59cf88ef -> 4e9b9dc7d8
M.guid_sub = function(guid, length)
  length = length or 10
  local g = guid:gsub('%-', '')
  return g:sub(1, length)
end


-- https://stackoverflow.com/a/5904469/1760643
-- example sql datetime: 2018-06-25 04:18:11.755792
M.sql_date_to_timestamp = function (sql_date_string)
  local sql_date_pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local year, month, day, hour, minute, seconds = sql_date_string:match(sql_date_pattern)
  return os.time({year = year, month = month, day = day, hour = hour, min = minute, sec = seconds})
end

return M