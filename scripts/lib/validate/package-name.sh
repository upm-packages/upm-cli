#!/bin/bash

if [ -z "${PACKAGE_NAME}" ]; then
  cat << __VALIDATE_PACKAGE_NAME__
ERROR: Please specify Package Name
__VALIDATE_PACKAGE_NAME__
  exit 1
fi
