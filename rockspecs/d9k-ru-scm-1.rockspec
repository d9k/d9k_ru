package = "d9k-ru"
version = "scm-1"
source = {
   url = "https://d9kd9k@bitbucket.org/d9kd9k/d9k_ru"
}
description = {
   summary = "d9k.ru personal site sources",
   homepage = "https://bitbucket.org/d9kd9k/d9k_ru",
   license = "GPL-3.0"
}
dependencies = {
   "lua == 5.2",
   "lua-log >= 0.1.6",
   "mobdebug >= 0.70"
}
build = {
   type = "builtin",
   modules = {
      ["conf.conf"] = "conf/conf.lua",
      ["controllers.main"] = "controllers/main.lua",
      index = "index.lua",
      ["index-magnet"] = "index-magnet.lua",
      ["start-server"] = "start-server.lua",
      ["tests.bootstrap"] = "tests/bootstrap.lua",
      ["tests.bootstrap_resty"] = "tests/bootstrap_resty.lua",
      ["tests.functional.dummy"] = "tests/functional/dummy.lua",
      ["tests.helper"] = "tests/helper.lua",
      ["tests.unit.dummy"] = "tests/unit/dummy.lua"
   },
   copy_directories = {
      "tests"
   }
}
