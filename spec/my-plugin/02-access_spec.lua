local helpers = require "spec.helpers"
local ipairs = ipairs

local PLUGIN_NAME = "my-plugin"


for _, strategy in ipairs({"off", "postgres"}) do
  describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()

      local bp = helpers.get_db_utils(strategy == "off" and "postgres" or strategy, nil, { PLUGIN_NAME })

      -- Inject a test route. No need to create a service, there is a default
      -- service which will echo the request.
      local route1 = bp.routes:insert({
        hosts = { "test1.com" },
      })
      -- add the plugin to test to the route we created
      bp.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = route1.id },
        config = {
          my_header = "X-Foo-Bar",
          my_string = "hello world"
        },
      }

      -- Inject a test route. No need to create a service, there is a default
      -- service which will echo the request.
      local route2 = bp.routes:insert({
        hosts = { "test2.com" },
      })
      -- add the plugin to test to the route we created
      bp.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = route2.id },
        config = {
          my_header = "X-Foo-Bar",
          my_string = "{vault://env/kong-vault-data/some_key_from_json}"
        },
      }

      helpers.setenv('KONG_MYPLUGIN_SOMEDATA', '{"foo":"bar","baz":"johndoe"}')
      helpers.setenv('KONG_VAULT_DATA', '{"some_key_from_json":"it works","foo":"bar"}')

      -- start kong
      assert(helpers.start_kong({
        -- set the strategy
        database   = strategy,
        -- use the custom test template to create a local mock server
        nginx_conf = "spec/fixtures/custom_nginx.template",
        -- make sure our plugin gets loaded
        plugins = "bundled," .. PLUGIN_NAME,
        -- write & load declarative config, only if 'strategy=off'
        declarative_config = strategy == "off" and helpers.make_yaml_file() or nil,
      }))
    end)

    lazy_teardown(function()
      helpers.stop_kong(nil, true)
    end)

    before_each(function()
      client = helpers.proxy_client()
    end)

    after_each(function()
      if client then client:close() end
    end)


    describe("response", function()
      it("gets 'X-Foo-Bar' and 'X-Vault-Value' header", function()
        local r = client:get("/request", {
          headers = {
            host = "test1.com"
          }
        })
        -- validate that the request succeeded, response status 200
        assert.response(r).has.status(200)
        -- now check the response to have the header
        local header_value = assert.response(r).has.header("X-Foo-Bar")
        local header_vault_value = assert.response(r).has.header("X-Vault-Value")
        -- validate the value of that header
        assert.equal("hello world", header_value)
        assert.equal("johndoe", header_vault_value)
      end)

      it("gets 'X-Foo-Bar' from vault reference", function()
        local r = client:get("/request", {
          headers = {
            host = "test2.com"
          }
        })
        -- validate that the request succeeded, response status 200
        assert.response(r).has.status(200)
        -- now check the response to have the header
        local header_value = assert.response(r).has.header("X-Foo-Bar")
        local header_vault_value = assert.response(r).has.header("X-Vault-Value")
        -- validate the value of that header
        assert.equal("it works", header_value)
        assert.equal("johndoe", header_vault_value)
      end)
    end)

  end)
end
