#!/bin/bash

cat << __USAGE__
Usage: ${PROGNAME} remove <subcommand>
  Remove something from Unity Package Project

Commands:
  package     Remove package from Packages/manifest.json

Options:
  -h, --help    Show usage.
__USAGE__
exit 0
