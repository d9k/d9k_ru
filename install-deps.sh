#!/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${PROJECT_DIR}

luarocks_command="luarocks build --local --only-deps rockspecs/d9k-ru-scm-1.rockspec"

echo "+ $luarocks_command"
$luarocks_command

echo "install luasql-postgres manually (see README.md for instructions)!"
