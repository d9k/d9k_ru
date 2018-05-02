local valua = require 'valua'

local article = {
  attributes = {
    -- implement .optional() !!!
    id = valua:new().number(),
    name = 'safe',
    -- TODO implement pattern validation! a-zA-Z0-9\-_ are allowed for this case
    system_name = 'safe',
    content_type = valua:new().in_list({'html', 'markdown'}),
    content = 'safe',
    active = valua:new().boolean(),
    -- TODO implement uuid validation!
    -- global_id uuid DEFAULT public.uuid_generate_v4() NOT NULL
  },
  db = {
    key = 'id',
    table = 'article',
  }
}

return article