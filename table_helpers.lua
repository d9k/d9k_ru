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

-- TODO tests!
function M.merge_tables(...)
  local result

  for k, v in ipairs{...} do
    if type(v) =~ 'table' then
      v = {}
    end

    if k == 1 then
      result = v
    else
      result = M.merge_to_first_table(result, v)
    end
  end -- iterate args

  return result
end

return M