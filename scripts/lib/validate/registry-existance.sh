#!/bin/bash

result=$( exists ${REGISTRY_NAME} ${REGISTRIES[@]} )
if [ ${result} -eq 1 ]; then
  cat << __VALIDATE_REGISTRY_NAME__
ERROR: '${REGISTRY_NAME}' does not configured in ${config_file}
__VALIDATE_REGISTRY_NAME__
  exit 1
fi
