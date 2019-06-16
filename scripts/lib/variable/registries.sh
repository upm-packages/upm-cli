#!/bin/bash

REGISTRIES=()
registry_list=""
registry_names_json=$(cat ${config_file} | jq '.registries|keys')
length=$(echo ${registry_names_json} | jq 'length')
for index in $( seq 0 $(($length - 1)) )
do
  registry_name=$(echo ${registry_names_json} | jq -r ".[${index}]")
  REGISTRIES+=(${registry_name})
  registry_list="${registry_list}[${index}] ${registry_name}
"
done

source "${DIRECTORY}/scripts/lib/validate/registries.sh"
