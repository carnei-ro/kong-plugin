local typedefs = require "kong.db.schema.typedefs"
local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

return {
  name = plugin_name,
  fields = {
    {
      config = {
        type = "record",
        fields = {
          {
            my_number = {
              type = "number",
              default = 42, --"default" key is not obrigatory, but is a nice to have
              required = false,
            }
          },
          {
            my_boolean = {
              type = "boolean",
              default = false,
              required = true -- if required = true and "default" key is missing, user MUST configure it
            }
          },
          {
            my_string = {
              type = "string",
              required = false,
              referenceable = true -- this means it can be securely stored as a secret in a vault
            }
          },
          {
            my_header = typedefs.header_name{
              default = "X-Qux-Corge",
              required = true
            }
          },
          --check all typedefs https://github.com/Kong/kong/blob/master/kong/db/schema/typedefs.lua
          {
            my_map = {
              type = "map",
              keys = {
                type = "string"
              },
              required = false,
              values = {
                type = "string",
                required = true,
              },
              default = {
                mykey1 = "my_value1",
                mykey2 = "my_value2"
              }
            }
          },
          {
            my_record = {
              type = "record",
              required = false,
              fields = {
                {
                  field_n1 = {
                    type = "boolean",
                    default = false
                  },
                },
                {
                  field_n2 = {
                    type = "array",
                    elements = {
                      type = "string"
                    }
                  },
                },
                {
                  field_n3 = {
                    type = "record",
                    required = false,
                    fields = {
                      {
                        subfield_n3_1 = {
                          type = "string",
                          required = false
                        }
                      }
                    }
                  },
                },
              },
            }
          },
          -- default = { roles = { values_are_regex = false, accepted_values = { "Admin2", "admin" } } }
          {
            my_array_of_strings = {
              type = "array",
              elements = {
                type = "string"
              },
              default = {"foo", "bar"},
              required = false
            }
          },
          {
            my_restrictive_array = {
              type = "array",
              required = false,
              elements = {
                type = "string",
                one_of = {"GET", "POST", "PUT", "DELETE",}, -- check for more validations: https://docs.konghq.com/2.0.x/plugin-development/plugin-configuration/#describing-your-configuration-schema
              },
            }
          },
        },
        entity_checks = {
          -- Describe your plugin's entity validation rules across fields
          {
            conditional = {}
          },
        },
      },
    },
  },
}
