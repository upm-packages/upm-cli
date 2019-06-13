#!/bin/bash

if [ ! -e "Packages/manifest.json" ]; then
  cat << __VALIDATE_MANIFEST__
ERROR: Could not find Packages/manifest.json
  Make sure current directory
__VALIDATE_MANIFEST__
  exit 1
fi
