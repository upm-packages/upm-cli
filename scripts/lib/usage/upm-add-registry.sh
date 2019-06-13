#!/bin/bash

cat << __USAGE__
Usage: ${PROGNAME} add registry <registry_name>
  Add registry into Packages/manifest.json

Note:
  Launch interactive shell if parameters are not specified.

Parameters:
  registry_name   Name of registry configured in ~/.upm-config.json

Options:
  -h, --help    Show usage.
__USAGE__
exit 0
