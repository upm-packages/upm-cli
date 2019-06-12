#!/bin/bash

function exists() {
  needle=$1; shift
  haystack=$@
  for item in ${haystack}; do
    if [ "${needle}" = "${item}" ]; then
      echo 0
      return
    fi
  done
  echo 1
  return
}

REGISTRY_NAME="$1"
PACKAGE_NAME="$2"
DISPLAY_NAME="$3"
DESCRIPTION="$4"
echo $REGISTRY_NAME
echo $PACKAGE_NAME
echo $DISPLAY_NAME
echo $DESCRIPTION

set -ue

if [ ! -e "${HOME}/.npmrc" ]; then
  cat << __VALIDATE_NPMRC__
ERROR: Could not find ${HOME}/.npmrc
  Please login to upm registry with 'npm login'
__VALIDATE_NPMRC__
  exit 1
fi

if [ ! -e "${HOME}/.upm-config.json" ]; then
  cat << __VALIDATE_UPM_CONFIG__
ERROR: Could not find ${HOME}/.upm-config.json
  Please create like below configuration file

{
  "registries": {
    "upm-packages.dev": {
      "name": "Unofficial Unity Package Manager Registry",
      "protocol": "https",
      "hostname": "upm-packages.dev",
      "scopes": [
        "dev.monry.upm"
      ],
      "unity_version": "2019.1",
      "author": {
        "name": "Tetsuya Mori",
        "url": "https://me.monry.dev/",
        "email": "monry@example.com"
      },
      "license": {
        "type": "MIT",
        "url": "https://monry.mit-license.org"
      },
      "repository": {
        "type": "git",
        "user": "monry",
        "organization": ""
      },
      "domain": "dev.monry.upm"
    }
  }
}
__VALIDATE_UPM_CONFIG__
  exit 1
fi

config_file="${HOME}/.upm-config.json"

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

if [ ${#REGISTRIES[@]} -eq 0 ]; then
  cat << __VALIDATE_REGISTRY_LOGIN__
ERROR: You seems to be are not logged in to any registry
__VALIDATE_REGISTRY_LOGIN__
  exit 1
fi

if [[ -n "${REGISTRY_NAME}" ]]; then
  result=$( exists ${REGISTRY_NAME} ${REGISTRIES[@]} )
  if [ ${result} -eq 1 ]; then
    cat << __VALIDATE_REGISTRY_NAME__
ERROR: '${REGISTRY_NAME}' does not configured in ${config_file}
__VALIDATE_REGISTRY_NAME__
    exit 1
  fi
else
  if [ ${#REGISTRIES[@]} -eq 1 ]; then
    REGISTRY_INDEX=1
  else
    cat << __SELECT_REGISTRY__
Registry list:
${registry_list}
__SELECT_REGISTRY__

    read -p "Registry [1..${index}]: " REGISTRY_INDEX

    if [[ ! ${REGISTRY_INDEX} =~ ^[0-9]+$ ]] || [ ${REGISTRY_INDEX} -lt 1 ] || [ ${REGISTRY_INDEX} -gt ${#REGISTRIES[@]} ]; then
      cat << __VALIDATE_REGISTRY__
ERROR: Choice value in [0..${index}]
__VALIDATE_REGISTRY__
      exit 1
    fi
  fi
  REGISTRY_INDEX=$((REGISTRY_INDEX - 1))
  REGISTRY_NAME=${REGISTRIES[${REGISTRY_INDEX}]}
fi

[[ -n "${PACKAGE_NAME}" ]] || read -p "Package Name (ex: CAFU.Foo.Bar): " PACKAGE_NAME

if [ -z "${PACKAGE_NAME}" ]; then
  cat << __VALIDATE_PACKAGE_NAME__
ERROR: Please specify Package Name
__VALIDATE_PACKAGE_NAME__
  exit 1
fi

[[ -n "${DISPLAY_NAME}" ]] || read -p "Display Name (ex: CAFU FooBar): " DISPLAY_NAME

if [ -z "${DISPLAY_NAME}" ]; then
  cat << __VALIDATE_DISPLAY_NAME__
ERROR: Please specify Display Name
__VALIDATE_DISPLAY_NAME__
  exit 1
fi

[[ -n "${DESCRIPTION}" ]] || read -p "Description: " DESCRIPTION


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

if [ -d "${repository_name}" ]; then
  cat << __VALIDATE_DIRECTORY__
ERROR: Directory '${repository_name}' has already exists
__VALIDATE_DIRECTORY__
  exit 1
fi

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
