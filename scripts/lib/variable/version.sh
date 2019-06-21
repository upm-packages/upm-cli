#!/bin/bash

if [ -z "${VERSION}"]; then
  registry_url=$(echo ${matched_registry} | jq -r ".url")
  package_info_url="${registry_url}/${PACKAGE_ID}"
  VERSION=$(curl -s ${package_info_url} | jq -r ".\"dist-tags\".latest")
fi

[[ -n "${VERSION}" ]] || read -p "Version (ex: 1.2.3-preview.1): " VERSION
