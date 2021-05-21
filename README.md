Kong plugin template
====================

summary: Template for kong plugin

This template was designed to work with the
[`kong-pongo`](https://github.com/Kong/kong-pongo), `docker` and `docker-compose`

Install pongo:

```bash
cd ~
PATH=$PATH:~/.local/bin
git clone git@github.com:Kong/kong-pongo.git
mkdir -p ~/.local/bin
ln -s $(realpath kong-pongo/pongo.sh) ~/.local/bin/pongo
```

<!-- BEGINNING OF KONG-PLUGIN DOCS HOOK -->
## Plugin Priority

**1000**

## Plugin Version

**0.1.0-1**

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
- name: kong-plugin
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
