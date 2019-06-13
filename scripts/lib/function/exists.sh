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
