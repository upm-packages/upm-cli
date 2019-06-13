#!/bin/bash

source "${DIRECTORY}/scripts/lib/function/exists.sh"

REGISTRY_NAME="$1"

set -ue

source "${DIRECTORY}/scripts/lib/validate/npmrc.sh"
source "${DIRECTORY}/scripts/lib/validate/upm-config.sh"

config_file="${HOME}/.upm-config.json"
manifest_file="Packages/manifest.json"

source "${DIRECTORY}/scripts/lib/variable/registries.sh"
source "${DIRECTORY}/scripts/lib/variable/registry-name.sh"

registry_json=$(cat ${config_file} | jq ".\"registries\".\"${REGISTRY_NAME}\"" | jq '{name: .name, url: (.protocol + "://" + .hostname), scopes: .scopes}')

filter=".scopedRegistries |= . + [${registry_json}]"
if [ ! -f "Packages/manifest.json" ]; then
  if [ ! -d "Packages" ]; then
    mkdir -p "Packages"
  fi
  echo "{}" > Packages/manifest.json
fi
manifest_json=$(cat ${manifest_file} | jq "${filter}")
echo ${manifest_json} | jq -M '.' > ${manifest_file}
