#!/bin/bash

[[ -n "${VERSION}" ]] || read -p "Version (ex: 1.2.3-preview.1): " VERSION

source "${DIRECTORY}/scripts/lib/validate/version.sh"
