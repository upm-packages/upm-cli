#!/bin/bash

[[ -n "${PACKAGE_ID}" ]] || read -p "Full-Qualified Package Name (ex: dev.monry.upm.some-package): " PACKAGE_ID

source "${DIRECTORY}/scripts/lib/validate/package-id.sh"
source "${DIRECTORY}/scripts/lib/validate/matched-registry.sh"
