#!/bin/bash

if [ ${#REGISTRIES[@]} -eq 0 ]; then
  cat << __VALIDATE_REGISTRY_LOGIN__
ERROR: You seems to be are not logged in to any registry
__VALIDATE_REGISTRY_LOGIN__
  exit 1
fi
