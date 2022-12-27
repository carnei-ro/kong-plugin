-- Always use functions as locals variables
local kong = kong
local type = type
local write = require('pl.pretty').write

local _M = {} --empty table to receive our functions

local function my_local_function(my_param1) --this function only will be used by this plugin
  -- silly example function, return table as string
  if type(my_param1) == "table" then
    return write(my_param1)
  end
  return my_param1
end

function _M.execute(conf)
  local header_value = conf.my_string and conf.my_string or "my_string was empty"
  my_local_function({["lua"] = "table", ["can"] = {"be a dict", "be an array"} })

  kong.response.set_header(conf.my_header, header_value)

  -- example new feature "vaults" - accessing key "baz" from "stringfied json" from env var "KONG_MYPLUGIN_SOMEDATA"
  local value, err = kong.vault.get("{vault://env/kong-myplugin-somedata/baz}")
  if err then
    kong.log.err("Error getting vault value: ", err)
  end
  if value then
    kong.response.set_header("X-Vault-Value", value)
  end
end

return _M
