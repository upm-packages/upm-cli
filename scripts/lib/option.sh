#!/bin/bash

PARAM=()
HELP=0
COMMAND=""
SUBCOMMAND=""
for OPT in "$@"; do
  case "${OPT}" in
    'init' )
      COMMAND="init"; shift
      source "${DIRECTORY}/scripts/lib/option/upm-init.sh"
      break
      ;;
    'add' )
      COMMAND="add"; shift

      case "$1" in
        'registry' )
          SUBCOMMAND="registry"; shift
          source "${DIRECTORY}/scripts/lib/option/upm-add-registry.sh"
          break
          ;;
        'package' )
          SUBCOMMAND="package"; shift
          source "${DIRECTORY}/scripts/lib/option/upm-add-package.sh"
          break
          ;;
        '' )
          HELP=1; shift
          ;;
        * )
          ;;
      esac
      ;;
    'remove' )
      COMMAND="remove"; shift

      case "$1" in
        'package' )
          SUBCOMMAND="package"; shift
          source "${DIRECTORY}/scripts/lib/option/upm-remove-package.sh"
          break
          ;;
        '' )
          HELP=1; shift
          ;;
        * )
          ;;
      esac
      ;;
    'help' )
      HELP=1; shift
      ;;
    '-v' | '--version' )
      shift
      cat "${DIRECTORY}/VERSION.txt"
      exit 0
      ;;
    '-h' | '--help' )
      HELP=1; shift
      ;;
    '--' | '-' )
      shift
      PARAM+=( "$@" )
      break
      ;;
    -* )
      echo "${PROGNAME}: illegal option -- '$( echo $1 | sed 's/^-*//' )'" 1>&2
      exit 1
      ;;
    * )
      echo $OPT
      if [[ -n "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        PARAM+=( "$1" ); shift
      fi
      ;;
  esac
done
