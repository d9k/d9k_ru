-- made by d9k

local table_helpers = require 'helpers.table'
local net_url = require 'net.url'
local requests = require 'requests'
local pretty_format = require "thirdparty_libs.pprint".pformat

local M = {
  FLICKR_API_URL = 'https://api.flickr.com/services/rest/',
  log_function = nil,
  log_enabled = true,
  api_key = nil
}

M.log = function(...)
  if M.log_enabled and M.log_function ~= nil then
    return M.log_function(...)
  end
end

M.try_parse_json_result = function(response, url)
  local json_result = response.text
  local result, json_error = table_helpers.safe_from_json(json_result)

  if json_error then
    -- TODO to log and print?
    M.log("\n" .. 'Request result text:' .. "\n")
    M.log('Url requested: ' .. url)
    M.log('Error parsing json from string: ' .. json_result)
  end

  return result
end


-- @see https://www.flickr.com/services/api/flickr.people.getPublicPhotos.html
-- @see https://www.flickr.com/services/api/explore/flickr.people.getPublicPhotos
-- doesn't require auth
--
-- for extras description @see https://www.flickr.com/services/api/flickr.photos.getSizes.html
M.get_public_photos = function(user_id, arguments)
  local log_prefix = 'in flickr.get_public_photos: '

  local args = table_helpers.merge({
      user_id = user_id,
      method = 'flickr.people.getPublicPhotos',
      ['format'] = 'json',
      nojsoncallback = 1,
      api_key = M.api_key,
    },
    arguments
  )

  local url = M.FLICKR_API_URL .. '?' .. net_url.buildQuery(args)
  M.log(log_prefix .. 'request url: ' .. url)

  local response = requests.get(url)
  return response
--  return M.try_parse_json_result(response, url)
end

return M
