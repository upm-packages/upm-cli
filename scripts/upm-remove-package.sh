#!/bin/bash

set -ue

source "${DIRECTORY}/scripts/lib/validate/package-json.sh"

manifest_file="Packages/manifest.json"
package_json_file="Assets/package.json"

source "${DIRECTORY}/scripts/lib/variable/package-id.sh"

package_id=${PACKAGE_ID}

manifest_json=$(cat ${manifest_file} | jq "del(.dependencies.\"${package_id}\")")
echo ${manifest_json} | jq -M '.' > ${manifest_file}
package_json=$(cat ${package_json_file} | jq "del(.dependencies.\"${package_id}\")")
echo ${package_json} | jq -M '.' > ${package_json_file}
