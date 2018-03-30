local auth = {}

function auth.login(page)

  local login = page.POST.login or ''

  if page.POST.submit then

  end

  page:render('login', {login = login})
end

return auth