M = {}

M.not_found = function(page, route_name)
    page:render('error/404', {route_name = route_name})
end


return M