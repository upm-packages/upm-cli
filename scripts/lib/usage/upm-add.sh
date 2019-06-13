#!/bin/bash

cat << __USAGE__
Usage: ${PROGNAME} add <subcommand>
  Add something into Unity Package Project

Commands:
  registry    Add registry settings into Packages/manifest.json
  package     Add package into Packages/manifest.json

Options:
  -h, --help    Show usage.
__USAGE__
exit 0
