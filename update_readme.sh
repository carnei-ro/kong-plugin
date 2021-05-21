#!/bin/sh

PLUGIN_PRIORITY=$(grep -ER 'PRIORITY( )*?=( )*?[0-9]+' 2>&1| grep handler.lua | grep -Eo '(PRIORITY.*[0-9]+)')

BEGIN=$(nl -ba README.md | grep 'BEGINNING OF KONG-PLUGIN DOCS HOOK' | awk '{print $1}')
END=$(nl -ba README.md | grep 'END OF KONG-PLUGIN DOCS HOOK' | awk '{print $1}')

head -n${BEGIN} README.md > README-B
tail -n +${END} README.md > README-E

echo -e "## Plugin Priority\n\n${PLUGIN_PRIORITY}\n" >> README-B
docker run -it --rm leandrocarneiro/kong-plugin-schema-to-markdown:latest $1 | sed "s/\r//g" >> README-B
cat README-B README-E > README.md
rm -f README-B README-E
