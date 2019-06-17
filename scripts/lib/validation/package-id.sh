#!/bin/bash

if [ -z "${PACKAGE_ID}" ]; then
  cat << __VALIDATE_PACKAGE_ID__
ERROR: Please specify Package ID
__VALIDATE_PACKAGE_ID__
  exit 1
fi
