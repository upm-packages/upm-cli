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
manifest_file="Packages/manifest.json"

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
  result=$( exists "${REGISTRY_NAME}" ${REGISTRIES[@]} )
  if [ ${result} -eq 1 ]; then
    cat << __VALIDATE_REGISTRY_NAME__
ERROR: '${REGISTRY_NAME}'' does not configured in ${config_file}
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
    REGISTRY_INDEX=$((REGISTRY_INDEX - 1))
    REGISTRY_NAME=${REGISTRIES[${REGISTRY_INDEX}]}
  fi
fi

registry_json=$(cat ${config_file} | jq ".\"registries\".\"${REGISTRY_NAME}\"" | jq '{name: .name, url: (.protocol + "://" + .hostname), scopes: .scopes}')

filter=".scopedRegistries |= . + [${registry_json}]"
manifest_json=$(cat ${manifest_file} | jq "${filter}")
echo ${manifest_json} | jq -M '.' > ${manifest_file}
