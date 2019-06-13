#!/bin/bash

if [ ${#REGISTRIES[@]} -eq 0 ]; then
  cat << __VALIDATE_REGISTRY_LOGIN__
ERROR: You seems to be are not logged in to any registry
__VALIDATE_REGISTRY_LOGIN__
  exit 1
fi

if [[ -n "${REGISTRY_NAME}" ]]; then
  result=$( exists ${REGISTRY_NAME} ${REGISTRIES[@]} )
  if [ ${result} -eq 1 ]; then
    cat << __VALIDATE_REGISTRY_NAME__
ERROR: '${REGISTRY_NAME}' does not configured in ${config_file}
__VALIDATE_REGISTRY_NAME__
    exit 1
  fi
else
  if [ ${#REGISTRIES[@]} -eq 1 ]; then
    REGISTRY_INDEX=1
  else
    cat << __SELECT_REGISTRY__
Registry list:
${registry_list}
__SELECT_REGISTRY__

    read -p "Registry [1..${index}]: " REGISTRY_INDEX

    if [[ ! ${REGISTRY_INDEX} =~ ^[0-9]+$ ]] || [ ${REGISTRY_INDEX} -lt 1 ] || [ ${REGISTRY_INDEX} -gt ${#REGISTRIES[@]} ]; then
      cat << __VALIDATE_REGISTRY__
ERROR: Choice value in [0..${index}]
__VALIDATE_REGISTRY__
      exit 1
    fi
  fi
  REGISTRY_INDEX=$((REGISTRY_INDEX - 1))
  REGISTRY_NAME=${REGISTRIES[${REGISTRY_INDEX}]}
fi
