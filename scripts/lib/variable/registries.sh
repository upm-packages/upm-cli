#!/bin/bash

REGISTRIES=()
registry_list=""
index=0
for line in `cat ${HOME}/.npmrc`
do
  if [[ ${line} =~ ^//([^/]+)/:_authToken.*$ ]]; then
    host=${BASH_REMATCH[1]}
    index=$((++index))
    REGISTRIES+=($host)
    registry_list="${registry_list}[${index}] ${host}
"
  fi
done

source "${DIRECTORY}/scripts/lib/validate/registries.sh"
