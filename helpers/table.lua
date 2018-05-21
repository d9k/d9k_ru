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

function M.append_arrays(...)
  return M._call_method_on_arguments_pairs('append_to_first_array', {{}, ...})
end

function M.clone_table(t)
  return M.merge_to_first_table({}, t)
end

function M.table_move_keys(t, keys_to_from)
  local c = M.merge_tables(t)
  for key_to, key_from in pairs(keys_to_from) do
    c[key_to], c[key_from] = c[key_from], nil
  end
  return c
end

-- @see https://stackoverflow.com/a/19266578/1760643
-- Usage:
-- for _,k in pairs(table_helpers.sorted_keys(mytable)) do
--  print(k, mytable[k])
-- end
function M.sorted_keys(t, sortFunction)
  local keys, len = {}, 0
  for k,_ in pairs(t) do
    len = len + 1
    keys[len] = k
  end
  table.sort(keys, sortFunction)
  return keys
end


return M
