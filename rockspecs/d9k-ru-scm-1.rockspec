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
   "mobdebug >= 0.70",

   -- install luasql-postgres manually!
   -- `sudo apt install libpq-dev`
   -- `sudo luarocks PGSQL_INCDIR=/usr/include/postgresql/ install luasql-postgres`
   --
   -- (lua files will be installed to ./share/lua/5.1/sailor/db/luasql_common.lua)
--   "luasql-postgres >= 2.3.5-2",
   "html-entities >= 1.3.0-1",
   "net-url >= 0.9",
   "lua-requests >= 1.1",
   -- @see https://github.com/keplerproject/md5
   "md5 >= 1.2", -- used by lua-requests too
   "lua-cjson = 2.1.0", -- cap version due to bug @see https://github.com/mpx/lua-cjson/issues/56 (lua-cjson is a dependency for lua-requests)
   "penlight >= 1.5",
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
