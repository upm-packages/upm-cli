#!/bin/bash

set -ue

source "${DIRECTORY}/scripts/lib/validation/manifest-json.sh"

manifest_file="Packages/manifest.json"
package_json_file="Assets/package.json"

source "${DIRECTORY}/scripts/lib/variable/package-id.sh"
source "${DIRECTORY}/scripts/lib/validation/package-id.sh"
source "${DIRECTORY}/scripts/lib/variable/matched-registry.sh"
source "${DIRECTORY}/scripts/lib/validation/matched-registry.sh"

package_id=${PACKAGE_ID}

current_version_manifest=$(cat ${manifest_file} | jq -r ".dependencies.\"${package_id}\"")
if [ "${current_version_manifest}" = "null" ]; then
  cat << __WARNING__
WARNING: "${package_id}" does not contains in "${manifest_file}"
__WARNING__
else
  manifest_json=$(cat ${manifest_file} | jq "del(.dependencies.\"${package_id}\")")
  echo ${manifest_json} | jq -M '.' > ${manifest_file}
fi

if [ -f ${package_json_file} ]; then
  current_version_package=$(cat ${package_json_file} | jq -r ".dependencies.\"${package_id}\"")
  if [ "${current_version_package}" = "null" ]; then
    cat << __WARNING__
WARNING: "${package_id}" does not contains in "${package_json_file}"
__WARNING__
  else
    package_json=$(cat ${package_json_file} | jq "del(.dependencies.\"${package_id}\")")
    echo ${package_json} | jq -M '.' > ${package_json_file}
  fi
fi

cat << __MESSAGE__
Successfully remove package "${package_id}" from project 🗑
__MESSAGE__