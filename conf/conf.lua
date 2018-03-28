private_conf = require 'conf/private_conf'
table_helpers = require 'table_helpers'

local conf = {
	sailor = {
		app_name = 'D9k.ru',
		default_static = nil, -- If defined, default page will be a rendered lp as defined.
							  -- Example: 'maintenance' will render /views/maintenance.lp
		default_controller = 'main',
		default_action = 'index',
		theme = 'default',
		layout = 'main',
		route_parameter = 'r',
		default_error404 = 'error/404',
		enable_autogen = false, -- default is false, should be true only in development environment
		friendly_urls = true,
		max_upload = 1024 * 1024,
		environment = "development",  -- this will use db configuration named development
		hide_stack_trace = false, -- false recommended for development, true recommended for production
    access_module = {
      default_login = 'admin',	    -- Default login details
      default_password = 'demo',
      grant_time = 60 * 60 * 24 * 5, 			-- in seconds
      model = 'user',					-- Setting this field will deactivate default login details and activate below fields
      login_attributes = {'login', 'email'}, -- Allows multiple options, for example, username or email. The one used to hash the
      password_attribute = 'password_hash', --     password should come first.
      hashing = true
    }
	},

  -- db config is at the private_conf.lua

	smtp = {
		server = '',
		user = '',
		pass = '',
		from = ''
	},

	lua_at_client = {
		vm = "starlight", -- starlight is default. Other options are moonshine, lua51js and luavmjs. They need to be downloaded.
	},

	debug = {
		inspect = true,
    breakpoints = true
	},

  log = {
    default = {
      max_log_level = 'trace'
    },
    console_default = {
      _class = 'log.writer.console.color'
    },
    file_default = {
      _class = 'log.writer.file',
      log_dir = './runtime/logs',
      log_name = 'events.log',
      flush_interval = 0,
      close_file = true,
      reuse = true
    }
  }
}

conf = table_helpers.merge_tables(conf, private_conf)
return conf
