#!/bin/sh

if [ -z "${matched_registry}" ]; then
  cat << __VALIDATE_MATCH__
ERROR: Could not find registry for ${PACKAGE_ID}
__VALIDATE_MATCH__
  exit 1
fi
