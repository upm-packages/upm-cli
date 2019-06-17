#!/bin/bash

if [ -z "${DISPLAY_NAME}" ]; then
  cat << __VALIDATE_DISPLAY_NAME__
ERROR: Please specify Display Name
__VALIDATE_DISPLAY_NAME__
  exit 1
fi
