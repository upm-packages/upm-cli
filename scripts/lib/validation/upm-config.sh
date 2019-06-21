#!/bin/bash

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
      "license": "MIT",
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
