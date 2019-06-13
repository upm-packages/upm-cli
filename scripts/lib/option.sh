#!/bin/bash

PARAM=()
HELP=0
COMMAND=""
SUBCOMMAND=""
for OPT in "$@"; do
  case "${OPT}" in
    'init' )
      COMMAND="init"; shift
      ;;
    'add' )
      COMMAND="add"; shift

      case "$1" in
        'registry' )
          SUBCOMMAND="registry"; shift
          ;;
        'package' )
          SUBCOMMAND="package"; shift
          ;;
        * )
          ;;
      esac
      ;;
    'help' )
      HELP=1; shift
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
      if [[ -n "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        PARAM+=( "$1" ); shift
      fi
      ;;
  esac
done
