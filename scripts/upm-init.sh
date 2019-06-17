#!/bin/bash

set -ue

source "${DIRECTORY}/scripts/lib/function/exists.sh"

source "${DIRECTORY}/scripts/lib/validation/npmrc.sh"
source "${DIRECTORY}/scripts/lib/validation/upm-config.sh"

config_file="${HOME}/.upm-config.json"

source "${DIRECTORY}/scripts/lib/variable/registries.sh"
source "${DIRECTORY}/scripts/lib/validation/registries.sh"

if [[ -z "${REGISTRY_NAME}" ]]; then
  source "${DIRECTORY}/scripts/lib/variable/registry-index.sh"
  source "${DIRECTORY}/scripts/lib/validation/registry-index.sh"
  source "${DIRECTORY}/scripts/lib/variable/registry-name.sh"
fi
source "${DIRECTORY}/scripts/lib/validation/registry-existance.sh"

source "${DIRECTORY}/scripts/lib/variable/package-name.sh"
source "${DIRECTORY}/scripts/lib/validation/package-name.sh"

source "${DIRECTORY}/scripts/lib/variable/display-name.sh"
source "${DIRECTORY}/scripts/lib/validation/display-name.sh"

source "${DIRECTORY}/scripts/lib/variable/description.sh"
# Description has no validation

registry_json=$(cat ${config_file} | jq ".\"registries\".\"${REGISTRY_NAME}\"")
registry_hostname=$(echo ${registry_json} | jq -r '."hostname"')
registry_protocol=$(echo ${registry_json} | jq -r '."protocol"')

package_domain=$(echo ${registry_json} | jq -r '."domain"')
package_name=$(echo ${PACKAGE_NAME} | tr '[:upper:]' '[:lower:]')
package_name=${package_name//\./-}
display_name=${DISPLAY_NAME}
description=${DESCRIPTION}
unity_version=$(echo ${registry_json} | jq -r '."unity_version"')
author_name=$(echo ${registry_json} | jq -r '."author"."name"')
author_url=$(echo ${registry_json} | jq -r '."author"."url"')
author_email=$(echo ${registry_json} | jq -r '."author"."email"')
license_type=$(echo ${registry_json} | jq -r '."license"."type"')
license_url=$(echo ${registry_json} | jq -r '."license"."url"')
repository_type=$(echo ${registry_json} | jq -r '."repository"."type"')
repository_user=$(echo ${registry_json} | jq -r '."repository"."user"')
if [ -z "${repository_user}" ]; then
  repository_user=$(echo ${registry_json} | jq -r '."repository"."organization"')
fi
repository_name=${PACKAGE_NAME//\./-}

if [ -d "${repository_name}" ]; then
  cat << __VALIDATE_DIRECTORY__
ERROR: Directory '${repository_name}' has already exists
__VALIDATE_DIRECTORY__
  exit 1
fi

package_json=$(cat << __PACKAGE_JSON__
{
  "name": "${package_domain}.${package_name}",
  "displayName": "${display_name}",
  "version": "0.0.1",
  "unity": "${unity_version}",
  "description": "${description}",
  "author": {
    "name": "${author_name}",
    "url": "${author_url}",
    "email": "${author_email}"
  },
  "license": {
    "type": "${license_type}",
    "url": "${license_url}"
  },
  "keywords": [
  ],
  "category": "",
  "dependencies": {
  },
  "repository": {
    "type": "${repository_type}",
    "url": "https://github.com/${repository_user}/${repository_name}"
  }
}
__PACKAGE_JSON__
)

mkdir -p "${repository_name}/Assets"
cd "${repository_name}"
echo ${package_json} | jq -M '.' > Assets/package.json
echo "registry=${registry_protocol}://${registry_hostname}" > .npmrc
echo "# ${display_name}" > Assets/README.md
cat > Assets/.npmignore << __NPMIGNORE__
.npmignore
yarn-debug.log*
yarn-error.log*
Plugins/
Plugins.meta

__NPMIGNORE__
curl -so .gitignore https://gist.githubusercontent.com/monry/c23a36851466c5c63659aa24405778ca/raw/a91f9250f576d03ab5ffdf13c5efa6b69d311f60/Unity.gitignore
git init
git remote add origin git@github.com:${repository_user}/${repository_name}.git

cat << __MESSAGE__
Finish prepare to developing Unity Package !
🚀 What's next ?
  cd ${repository_name}
  # edit Assets/README.md
  # edit Assets/package.json if needed
  git add .
  git commit -m ":baby: Initial commit"
  git push origin master

Enjoy development 🎉
__MESSAGE__
