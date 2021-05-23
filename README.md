# Kong Plugin Template

summary: Template for kong plugin

This template was designed to work with the
[`kong-pongo`](https://github.com/Kong/kong-pongo), `docker` and `docker-compose`.

`curl`, `jq`, `make` also needed.

Based on https://github.com/Kong/kong-plugin

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
- **README.md** file must contain "**summary:** line" with a single line description of the plugin
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

**1000**

## Plugin Version

**0.1.0**

## Configs

| name | type | required | default | validations |
| ---- | ---- | -------- | ------- | ----------- |
| config.my_number | **number** | false | <pre>42</pre> |  |
| config.my_boolean | **boolean** | true |  |  |
| config.my_string | **string** | false |  |  |
| config.my_header | **string** | true | <pre>X-Qux-Corge</pre> |  |
| config.my_map | **map[string][string]** (*check `'config.my_map' object`) | false | <pre>mykey2: my_value2<br/>mykey1: my_value1</pre> |  |
| config.my_record | object (*check '`config.my_record....`' records) | false |  |  |
| config.my_record.field_n1 | **boolean** | false |  |  |
| config.my_record.field_n2 | **array of strings** | false |  |  |
| config.my_record.field_n3 | object (*check '`config.my_record.field_n3....`' records) | false |  |  |
| config.my_record.field_n3.subfield_n3_1 | **string** | false |  |  |
| config.my_array_of_strings | **array of strings** | false | <pre>- foo<br/>- bar</pre> |  |
| config.my_restrictive_array | **array of strings** | false |  | <pre>- one_of:<br/>  - GET<br/>  - POST<br/>  - PUT<br/>  - DELETE</pre> |

### 'config.my_map' object

| keys_type | keys_validations | values_type | values_required | values_default | values_validations |
| --------- | ---------------- | ----------- | --------------- | -------------- | ------------------ |
| **string** |  | **string** | true |  |  |

## Usage

```yaml
---
plugins:
- name: my-plugin
  enabled: true
  config:
    my_number: 42
    my_boolean: false
    my_string: ''
    my_header: X-Qux-Corge
    my_map: {}
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
