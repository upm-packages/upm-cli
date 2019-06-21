#!/bin/bash

set -ue

source "${DIRECTORY}/scripts/lib/function/exists.sh"

source "${DIRECTORY}/scripts/lib/validation/npmrc.sh"
source "${DIRECTORY}/scripts/lib/validation/upm-config.sh"

config_file="${HOME}/.upm-config.json"
manifest_file="Packages/manifest.json"

source "${DIRECTORY}/scripts/lib/variable/registries.sh"
source "${DIRECTORY}/scripts/lib/validation/registries.sh"

if [ -z "${REGISTRY_NAME}" ]; then
  source "${DIRECTORY}/scripts/lib/variable/registry-index.sh"
  source "${DIRECTORY}/scripts/lib/validation/registry-index.sh"
  source "${DIRECTORY}/scripts/lib/variable/registry-name.sh"
fi
source "${DIRECTORY}/scripts/lib/validation/registry-existance.sh"

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

cat << __MESSAGE__
Successfully add registry "${REGISTRY_NAME}" to project 🗄
__MESSAGE__