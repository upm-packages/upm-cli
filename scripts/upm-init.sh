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
registry_name=$(echo ${registry_json} | jq -r '."name"')
registry_hostname=$(echo ${registry_json} | jq -r '."hostname"')
registry_protocol=$(echo ${registry_json} | jq -r '."protocol"')

project_name=${PACKAGE_NAME}
package_domain=$(echo ${registry_json} | jq -r '."domain"')
package_name=$(echo ${PACKAGE_NAME} | tr '[:upper:]' '[:lower:]')
display_name=${DISPLAY_NAME}
description=${DESCRIPTION}
unity_version=$(echo ${registry_json} | jq -r '."unity_version"')
author_name=$(echo ${registry_json} | jq -r '."author"."name"')
author_url=$(echo ${registry_json} | jq -r '."author"."url"')
author_email=$(echo ${registry_json} | jq -r '."author"."email"')
company_name="DefaultCompany"
if [ "null" != "$(echo ${registry_json} | jq -r '."company"."name"')" ]; then
  company_name=$(echo ${registry_json} | jq -r '."company"."name"')
fi
repository_type=$(echo ${registry_json} | jq -r '."repository"."type"')
repository_user=$(echo ${registry_json} | jq -r '."repository"."user"')
if [ -z "${repository_user}" ]; then
  repository_user=$(echo ${registry_json} | jq -r '."repository"."organization"')
fi
repository_name=${PACKAGE_NAME}
directory_name=${PACKAGE_NAME//\./-}
license="UNLICENSED"
license_url=""
if [ "string" = "$(echo ${registry_json} | jq -r '.license|type')" ]; then
  license=$(echo ${registry_json} | jq -r '.license')
elif [ "object" = "$(echo ${registry_json} | jq -r '.license|type')" ] && [ "null" != "$(echo ${registry_json} | jq -r '.license.type')" ]; then
  license=$(echo ${registry_json} | jq -r '.license.type')
  if [ "null" != "$(echo ${registry_json} | jq -r '.license.url')" ]; then
    license_url=$(echo ${registry_json} | jq -r '.license.url')
  fi
fi
publish_registry_hostname=$(echo ${registry_json} | jq -r '."publish"."hostname"')
if [ -z "${publish_registry_hostname}" ]; then
  publish_registry_hostname=${registry_hostname}
fi
publish_registry_protocol=$(echo ${registry_json} | jq -r '."publish"."protocol"')
if [ -z "${publish_registry_protocol}" ]; then
  publish_registry_protocol=${registry_protocol}
fi

if [ -d "${directory_name}" ]; then
  cat << __VALIDATE_DIRECTORY__
ERROR: Directory '${directory_name}' has already exists
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
  "license": "${license}",
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

mkdir -p "${directory_name}/Assets"
mkdir -p "${directory_name}/ProjectSettings"
cd "${directory_name}"
echo ${package_json} | jq -M '.' > Assets/package.json
echo "registry=${publish_registry_protocol}://${publish_registry_hostname}" > .npmrc

cat > Assets/README.md << __README__
![](https://github.com/${repository_user}/${repository_name}/workflows/Publish%20UPM%20Package/badge.svg)

# ${display_name}

## Installation

\`\`\`bash
upm add package ${package_domain}.${package_name}
\`\`\`

Note: \`upm\` command is provided by [this repository](https://github.com/upm-packages/upm-cli).

You can also edit \`Packages/manifest.json\` directly.

\`\`\`jsonc
{
  "dependencies": {
    // (snip)
    "${package_domain}.${package_name}": "[latest version]", 
    // (snip)
  },
  "scopedRegistries": [
    {
      "name": "${registry_name}",
      "url": "${registry_protocol}://${registry_hostname}",
      "scopes": [
        "${package_domain}"
      ]
    }
  ]
}
\`\`\`

## Usages

* 
__README__
ln -s Assets/README.md README.md

cat > Assets/CHANGELOG.md << __CHANGELOG__
# Changelog

__CHANGELOG__
ln -s Assets/CHANGELOG.md CHANGELOG.md

cat > Assets/.npmignore << __NPMIGNORE__
.npmignore
yarn-debug.log*
yarn-error.log*
Tests/
Tests.meta
__NPMIGNORE__

cat > ProjectSettings/ProjectSettings.asset << __PROJECT_SETTINGS__
%YAML 1.1
%TAG !u! tag:unity3d.com,2011:
--- !u!129 &1
PlayerSettings:
  companyName: ${company_name}
  productName: ${project_name}
  applicationIdentifier:
    Standalone: ${package_domain}.${package_name}
__PROJECT_SETTINGS__

cat > ProjectSettings/EditorSettings.asset << __EDITOR_SETTINGS__
%YAML 1.1
%TAG !u! tag:unity3d.com,2011:
--- !u!159 &1
EditorSettings:
  m_ProjectGenerationRootNamespace: ${PACKAGE_NAME}
__EDITOR_SETTINGS__

mkdir -p .github/workflows/
cat > .github/workflows/publish-upm-package.yml << __GITHUB_ACTIONS__
name: Publish UPM Package

on:
  release:
    types: [published]

jobs:
  publish:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - uses: monry/actions-upm-publish@v1
      with:
        npm_auth_token: \${{ secrets.NPM_AUTH_TOKEN }}
__GITHUB_ACTIONS__

curl -so .gitignore https://gist.githubusercontent.com/monry/c23a36851466c5c63659aa24405778ca/raw/a91f9250f576d03ab5ffdf13c5efa6b69d311f60/Unity.gitignore
git init
git remote add origin git@github.com:${repository_user}/${repository_name}.git
if [ -n "${license_url}" ]; then
  curl -so Assets/LICENSE.txt ${license_url}
  # GitHub does not support SymLink for LICENSE.txt
  curl -so LICENSE.txt ${license_url}
fi

cat << __MESSAGE__
Finish prepare to developing Unity Package !
🚀 What's next ?
  cd ${repository_name}
  # edit Assets/README.md
  # edit Assets/package.json if needed
  git add .
  git commit -m ":baby: Initial commit"
  git push origin master
  # create releases on GitHub

Enjoy development 🎉
__MESSAGE__
