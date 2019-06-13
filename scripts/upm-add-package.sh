#!/bin/bash

PACKAGE_NAME="$1"
VERSION="$2"

set -ue

if [ ! -e "Packages/manifest.json" ]; then
  cat << __VALIDATE_MANIFEST__
ERROR: Could not find Packages/manifest.json
  Make sure current directory
__VALIDATE_MANIFEST__
  exit 1
fi

manifest_file="Packages/manifest.json"
package_json_file="Assets/package.json"

[[ -n "${PACKAGE_NAME}" ]] || read -p "Full-Qualified Package Name (ex: dev.monry.upm.some-package): " PACKAGE_NAME

if [ -z "${PACKAGE_NAME}" ]; then
  cat << __VALIDATE_PACKAGE_NAME__
ERROR: Please specify Package Name
__VALIDATE_PACKAGE_NAME__
  exit 1
fi
package_name=${PACKAGE_NAME}

[[ -n "${VERSION}" ]] || read -p "Version (ex: 1.2.3-preview.1): " VERSION

if [ -z "${VERSION}" ]; then
  cat << __VALIDATE_VERSION__
ERROR: Please specify Version
__VALIDATE_VERSION__
  exit 1
fi
version=${VERSION}

package_name_digits=${package_name//./ }
domain_name=""
matched_registry=""
for digit in ${package_name_digits[@]}
do
  domain_name="${domain_name}.${digit}"
  domain_name=$(echo ${domain_name} | sed -e 's/^\.//')
  matched_registry=$(cat ${manifest_file} | jq ".scopedRegistries[] | select(.scopes[] == \"${domain_name}\")")
  [[ -n "${matched_registry}" ]] && break
done

if [ -z "${matched_registry}" ]; then
  cat << __VALIDATE_MATCH__
ERROR: Could not find registry for ${package_name}
__VALIDATE_MATCH__
  exit 1
fi

manifest_json=$(cat ${manifest_file} | jq ".dependencies |= . + {\"${package_name}\": \"${version}\"}")
echo ${manifest_json} | jq -M '.' > ${manifest_file}
package_json=$(cat ${package_json_file} | jq ".dependencies |= . + {\"${package_name}\": \"${version}\"}")
echo ${package_json} | jq -M '.' > ${package_json_file}
