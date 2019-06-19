#!/bin/bash

if [ ${#REGISTRIES[@]} -eq 1 ]; then
  REGISTRY_INDEX=1
else
  cat << __SELECT_REGISTRY__
Registry list:
${registry_list}
__SELECT_REGISTRY__

  read -p "Registry [1..${#REGISTRIES[@]}]: " REGISTRY_INDEX

  source "${DIRECTORY}/scripts/lib/validation/registry-index.sh"
fi
REGISTRY_INDEX=${REGISTRY_INDEX}
