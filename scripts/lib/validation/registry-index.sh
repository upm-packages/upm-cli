#!/bin/bash

if [[ ! ${REGISTRY_INDEX} =~ ^[0-9]+$ ]] || [ ${REGISTRY_INDEX} -le 0 ] || [ ${REGISTRY_INDEX} -gt ${#REGISTRIES[@]} ]; then
  cat << __VALIDATE_REGISTRY__
ERROR: Choice value in [1..${#REGISTRIES[@]}]
__VALIDATE_REGISTRY__
  exit 1
fi
