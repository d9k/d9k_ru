-- made by d9k
-- TODO separate to rock

local table_helpers = require 'helpers.table'
local net_url = require 'net.url'
local md5 = require 'md5'.sumhexa
local requests = require 'requests'
local pretty_format = require "thirdparty_libs.pprint".pformat

M = {
  LAST_FM_API_URL = 'https://ws.audioscrobbler.com/2.0/',
  log_function = nil,
  log_enabled = true,
}

M.log = function(...)
  if M.log_enabled and M.log_function ~= nil then
    return M.log_function(...)
  end
end

-- @see https://www.last.fm/api/mobileauth#4
M.calculate_signature = function(arguments, lastfm_shared_secret)
  assert(lastfm_shared_secret, 'lastfm_shared_secret is required')

  local log_prefix = 'in lastfm.calculate_signature: '
  local args = table_helpers.clone_table(arguments)

--[[
  Construct your api method signatures by first ordering all the parameters sent in your call alphabetically by parameter name and concatenating them into one string using a <name><value> scheme. So for a call to auth.getMobileSession you may have:

  api_keyxxxxxxxxmethodauth.getMobileSessionpasswordxxxxxxxusernamexxxxxxxx

  Ensure your parameters are utf8 encoded. Now append your secret to this string. Finally, generate an md5 hash of the resulting string.
]]--

  local hash_input_parts = {};
  args.format = nil

  for _, argument_name in pairs(table_helpers.sorted_keys(args)) do
    local argument_value = args[argument_name]
    table.insert(hash_input_parts, argument_name)
    table.insert(hash_input_parts, argument_value)
  end

  table.insert(hash_input_parts, lastfm_shared_secret)

  M.log(log_prefix .. 'hash_input_parts: ' .. pretty_format(hash_input_parts))

  local hash_input = table.concat(hash_input_parts, '')
  M.log(log_prefix .. 'hash_input: ' .. pretty_format(hash_input))

  local hash = md5(hash_input)

  return hash
end

-- https://www.last.fm/api/show/auth.getMobileSession
M.auth = function (lastfm_api_key, lastfm_shared_secret, username, password)
  local log_prefix = 'in lastfm.auth: '

  -- TODO
  local data = {
    api_key = lastfm_api_key,
--    lastfm_shared_secret = lastfm_shared_secret,
    username = username,
    password = password,
    method = 'auth.getMobileSession',
    ['format'] = 'json',
  }
  data['api_sig'] = M.calculate_signature(data, lastfm_shared_secret)

  M.log(log_prefix .. 'request data: ' .. pretty_format(data))

  local url = M.LAST_FM_API_URL .. '?' .. net_url.buildQuery(data)
  M.log(log_prefix .. 'request url: ' .. url)
--  response = requests.post(M.LAST_FM_API_URL, data)
  response = requests.post(url)

  return response

end

return M
