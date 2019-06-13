#!/bin/bash

if [[ -n "${REGISTRY_NAME}" ]]; then
  source "${DIRECTORY}/scripts/lib/validate/registry-existance.sh"
else
  if [ ${#REGISTRIES[@]} -eq 1 ]; then
    REGISTRY_INDEX=1
  else
    cat << __SELECT_REGISTRY__
Registry list:
${registry_list}
__SELECT_REGISTRY__

    read -p "Registry [1..${index}]: " REGISTRY_INDEX

    source "${DIRECTORY}/scripts/lib/validate/registry-index.sh"
  fi
  REGISTRY_INDEX=$((REGISTRY_INDEX - 1))
  REGISTRY_NAME=${REGISTRIES[${REGISTRY_INDEX}]}
fi
