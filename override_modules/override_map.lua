--local sailor = require 'sailor'

--sailor.log:info('override_modules.override_map reloaded')
package.loaded['sailor.page'] = require 'override_modules.sailor_page'
package.loaded['sailor.session'] = require 'override_modules.sailor_session'
package.loaded['sailor.form'] = require 'override_modules.sailor_form'
package.loaded['valua'] = require 'override_modules.valua'
package.loaded['sailor.db.luasql_common'] = require 'override_modules.sailor_db_luasql_common'
package.loaded['sailor.model'] = require 'override_modules.sailor_model'