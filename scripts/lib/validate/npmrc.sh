#!/bin/bash

if [ ! -e "${HOME}/.npmrc" ]; then
  cat << __VALIDATE_NPMRC__
ERROR: Could not find ${HOME}/.npmrc
  Please login to upm registry with 'npm login'
__VALIDATE_NPMRC__
  exit 1
fi
