#!/bin/bash

if [[ ! ${REGISTRY_INDEX} =~ ^[0-9]+$ ]] || [ ${REGISTRY_INDEX} -lt 0 ] || [ ${REGISTRY_INDEX} -gt ${#REGISTRIES[@]} ]; then
  echo "${REGISTRY_INDEX} / ${#REGISTRIES[@]}" > ~/tmp.txt
  cat << __VALIDATE_REGISTRY__
ERROR: Choice value in [0..${index}]
__VALIDATE_REGISTRY__
  exit 1
fi
