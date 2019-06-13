#!/bin/bash

[[ -n "${PACKAGE_NAME}" ]] || read -p "Package Name (ex: CAFU.Foo.Bar): " PACKAGE_NAME

source "${DIRECTORY}/scripts/lib/validate/package-name.sh"
