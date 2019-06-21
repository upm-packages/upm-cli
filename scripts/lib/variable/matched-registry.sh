#!/bin/sh

package_id_digits=${PACKAGE_ID//./ }
domain_name=""
matched_registry=""
for digit in ${package_id_digits[@]}
do
  domain_name="${domain_name}.${digit}"
  domain_name=$(echo ${domain_name} | sed -e 's/^\.//')
  matched_registry=$(cat ${manifest_file} | jq ".scopedRegistries[] | select(.scopes[] == \"${domain_name}\")")
  [[ -n "${matched_registry}" ]] && break
done
echo -n ""