local json = require 'cjson'

local M = {}

-- https://stackoverflow.com/a/1283608/1760643
function M.merge_to_first_table(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                M.merge_to_first_table(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end -- merge_to_first_table

function M._call_method_on_arguments_pairs(method_name, arguments)
  local result

  for k = 1, #arguments do
    local v = arguments[k]
    if type(v) ~= 'table' then
      v = {}
    end

    if k == 1 then
      result = v
    else
      -- calling method by name:
      result = M[method_name](result, v)
    end
  end -- iterate args

  return result
end

function M.append_to_first_array(t1, t2)
  for i=1, #t2 do
      t1[#t1+1] = t2[i]
  end
  return t1
end

-- TODO tests!
function M.merge_tables(...)
  return M._call_method_on_arguments_pairs('merge_to_first_table', {{}, ...})
end

M.merge = M.merge_tables

-- rename to append_lists
function M.append_arrays(...)
  return M._call_method_on_arguments_pairs('append_to_first_array', {{}, ...})
end

function M.clone_table(t)
  return M.merge_to_first_table({}, t)
end

M.clone = M.clone_table

function M.table_move_keys(t, keys_to_from)
  local c = M.clone(t)
  for key_to, key_from in pairs(keys_to_from) do
    c[key_to], c[key_from] = c[key_from], nil
  end
  return c
end

function M.items_count(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

M.count = M.items_count

function M.keys(t)
  local result = {}

  for k, _ in pairs(t) do
    table.insert(result, k)
  end

  return result
end

-- @see https://stackoverflow.com/a/19266578/1760643
-- Usage:
-- for _,k in pairs(table_helpers.sorted_keys(mytable)) do
--  print(k, mytable[k])
-- end
--
-- @see https://stackoverflow.com/a/15706820/1760643
--
-- sort_function example: `function(t,a,b) return t[b] < t[a] end`
function M.sorted_keys(t, sort_function)
  local keys, len = {}, 0
  for k,_ in pairs(t) do
    len = len + 1
    keys[len] = k
  end

  if sort_function then
      table.sort(keys, function(a,b) return sort_function(t, a, b) end)
  else
      table.sort(keys)
  end

  return keys
end

-- https://stackoverflow.com/a/32660766/1760643
function M.equal(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or M.equal(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

-- @param table t
-- @param table keys: list
-- @param boolean only_these_keys
-- @return boolean
function M.has_keys(t, keys, only_these_keys)
  if type(t) ~= 'table' then
    return false
  end

  local keys_checked = {}

  for _, key_name in pairs(keys) do
    if not t[key_name] then
      return false
    end
    keys_checked[key_name] = true
  end

  if only_these_keys and M.items_count(t) ~= M.items_count(keys_checked) then
    return false
  end

  return true;
end

-- @param table t
-- @param table keys: list
-- @return boolean
function M.has_only_keys(t, keys)
  return M.has_keys(t, keys, true)
end

-- php's array_flip analog https://secure.php.net/manual/en/function.array-flip.php
function M.swap_keys_with_values(t)
  local result = {}

  for key, value in pairs(t) do
    result[value] = key
  end

  return result
end

-- get read of CJSON's nulls
M.no_nulls = function(o)
  if o == json.null then
    return nil
  elseif type(o) == 'table' then
    for k, _ in pairs(o) do
      o[k] = M.no_nulls(o[k])
    end
  end
  return o
end

-- if decode fails, return table
-- @param string s
-- @return table|mixed
-- @return string|nil
function M.safe_from_json(s, get_rid_of_cjson_nulls)
  if get_rid_of_cjson_nulls ~= false then
    get_rid_of_cjson_nulls = true
  end

  local status, err_or_result = pcall(function ()
    return json.decode(s)
  end)

  if status then
    if get_rid_of_cjson_nulls then
      return M.no_nulls(err_or_result)
    else
      return err_or_result
    end
  else
    return {}, err_or_result
  end
end

function M.table_is_empty (s)
  for _, _ in pairs(s) do
    return false
  end
  return true
end


return M
