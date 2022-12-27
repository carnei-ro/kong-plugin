# Kong Plugin Template

summary: Template for kong plugin

This template was designed to work with the
[`kong-pongo`](https://github.com/Kong/kong-pongo), `docker` and `docker-compose`.

`curl`, `jq`, `make` also needed.

Based on [kong-plugin](https://github.com/Kong/kong-plugin)

Install pongo:

```bash
cd ~
PATH=$PATH:~/.local/bin
git clone git@github.com:Kong/kong-pongo.git
mkdir -p ~/.local/bin
ln -s $(realpath kong-pongo/pongo.sh) ~/.local/bin/pongo
```

## Developing

- Rename the directory inside `kong/plugins` and `spec` from **my-plugin** to your desired plugin name. Be careful to not overlap with existent Kong Plugins.
- **README.md** file must contain "**summary:**" with a single line description of the plugin
- Switch between DBLess or Postgres changing the **DOCKER_COMPOSE_FILE** variable at the `Makefile`
- If your plugin depends on external lua libraries (rocks), list them into **dependencies.conf** file
- Pre-Commit available - Depends on Kong running.
- `make help` to check available commands. Some of them:
  - `make start` to create the rockspec file and start a Kong container to serve the base for the development
  - `make reload` to reload Kong and the chages in plugin's code
  - `make stop` and/or `make clean` to cleaning it up
  - `make lint` and `make test` to run **pongo**
  - With Kong running: `make update_readme` to recreate the section between **KONG-PLUGIN DOCS HOOK** comments
  - `make logs` to check Kong logs
  - `make shell` to access Kong bash
  - `make resty-script` to execute **resty-script.lua** file. Useful to test some code
  - `make build` to generate the **.rock** file at the _./dist_ directory

<!-- BEGINNING OF KONG-PLUGIN DOCS HOOK -->
## Plugin Priority

Priority: **1000**

## Plugin Version

Version: **0.1.1**

## Config

&ast; This field is _referenceable_, which means it can be securely stored as a [secret](https://docs.konghq.com/gateway/latest/kong-enterprise/secrets-management/) in a vault. References must follow a [specific format](https://docs.konghq.com/gateway/latest/kong-enterprise/secrets-management/reference-format/).

| name | type | required | validations | default |
|-----|-----|-----|-----|-----|
| my_number | number | <pre>false</pre> |  | <pre>42</pre> |
| my_boolean | boolean | <pre>true</pre> |  | <pre>false</pre> |
| my_string* | string | <pre>false</pre> |  |  |
| my_header | string | <pre>true</pre> |  | <pre>X-Qux-Corge</pre> |
| my_map | map[string][string] | <pre>false</pre> |  | <pre>mykey1: my_value1<br/>mykey2: my_value2</pre> |
| my_record | record** | <pre>false</pre> |  |  |
| my_array_of_strings | array of strings | <pre>false</pre> |  | <pre>- foo<br/>- bar</pre> |
| my_restrictive_array | array of strings | <pre>false</pre> | <pre>- one_of:<br/>  - GET<br/>  - POST<br/>  - PUT<br/>  - DELETE</pre> |  |

### record** of field_n3

| name | type | required | validations | default |
|-----|-----|-----|-----|-----|
| subfield_n3_1 | string | <pre>false</pre> |  |  |

### record** of my_record

| name | type | required | validations | default |
|-----|-----|-----|-----|-----|
| field_n1 | boolean | <pre>false</pre> |  | <pre>false</pre> |
| field_n2 | array of strings | <pre>false</pre> |  |  |
| field_n3 | record** | <pre>false</pre> |  |  |

## Usage

```yaml
plugins:
  - name: my-plugin
    enabled: true
    config:
      my_number: 42
      my_boolean: false
      my_string: ''
      my_header: X-Qux-Corge
      my_map:
        mykey2: my_value2
        mykey1: my_value1
      my_record:
        field_n1: false
        field_n2: []
        field_n3:
          subfield_n3_1: ''
      my_array_of_strings:
        - foo
        - bar
      my_restrictive_array: []

```
<!-- END OF KONG-PLUGIN DOCS HOOK -->
