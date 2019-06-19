#!/bin/bash

REGISTRIES=()
registry_list=""
registry_names_json=$(cat ${config_file} | jq '.registries|keys')
length=$(echo ${registry_names_json} | jq 'length')
if [ $length -ge 1 ]; then
  for index in $( seq 1 ${length} )
  do
    registry_name=$(echo ${registry_names_json} | jq -r ".[$((index - 1))]")
    REGISTRIES+=(${registry_name})
    registry_list="${registry_list}[$((${index}))] ${registry_name}
"
  done
fi
