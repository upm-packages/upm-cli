#!/bin/bash

[[ -n "${DISPLAY_NAME}" ]] || read -p "Display Name (ex: CAFU FooBar): " DISPLAY_NAME

source "${DIRECTORY}/scripts/lib/validate/display-name.sh"
