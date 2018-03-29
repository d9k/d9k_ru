-- it is a cli command factory

local pformat = require 'thirdparty_libs.pprint'.pformat

local M = {}

function M.action(args)
  print(pformat(args))
end

function M.create(parser, action_callback)
  action_callback = action_callback or M.action
  local command_user = parser:command('u user'):action(action_callback)
  return command_user
end

return M