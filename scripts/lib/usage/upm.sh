#!/bin/bash

cat << __USAGE__
Usage: ${PROGNAME} <command>
  Command line interface for Unity Package Manager

Commands:
  init        Initialize Unity project for packages
  add         Add something into project
  remove      Remove something from project
  help        Show help

Options:
  -h, --help    Show usage.
__USAGE__
exit 0
