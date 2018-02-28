#!/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${PROJECT_DIR}

set -x
luarocks build --local --only-deps rockspecs/d9k-ru-scm-1.rockspec
