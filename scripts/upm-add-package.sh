#!/bin/bash

set -ue

source "${DIRECTORY}/scripts/lib/validation/manifest-json.sh"

manifest_file="Packages/manifest.json"
package_json_file="Assets/package.json"

source "${DIRECTORY}/scripts/lib/variable/package-id.sh"
source "${DIRECTORY}/scripts/lib/validation/package-id.sh"
source "${DIRECTORY}/scripts/lib/validation/matched-registry.sh"

source "${DIRECTORY}/scripts/lib/variable/version.sh"
source "${DIRECTORY}/scripts/lib/validation/version.sh"

package_id=${PACKAGE_ID}
version=${VERSION}

manifest_json=$(cat ${manifest_file} | jq ".dependencies |= . + {\"${package_id}\": \"${version}\"}")
echo ${manifest_json} | jq -M '.' > ${manifest_file}
package_json=$(cat ${package_json_file} | jq ".dependencies |= . + {\"${package_id}\": \"${version}\"}")
echo ${package_json} | jq -M '.' > ${package_json_file}
