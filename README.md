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
