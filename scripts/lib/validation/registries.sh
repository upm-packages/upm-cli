#!/bin/bash

if [ ${#REGISTRIES[@]} -eq 0 ]; then
  cat << __VALIDATE_REGISTRIES__
ERROR: No registries configured
__VALIDATE_REGISTRIES__
  exit 1
fi
