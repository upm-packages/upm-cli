#!/bin/bash

if [ -z "${VERSION}" ]; then
  cat << __VALIDATE_VERSION__
ERROR: Please specify Version
__VALIDATE_VERSION__
  exit 1
fi
