local main = {}

-- global
debug_mode = true

function main.index(page)
    if debug_mode then
        require('mobdebug').start('127.0.0.1')
    end
    page:render('index')
end

return main
