#!/bin/bash

for OPT in "$@"; do
  case "${OPT}" in
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

set +u

REGISTRY_NAME="${PARAM[0]}"
PACKAGE_NAME="${PARAM[1]}"
DISPLAY_NAME="${PARAM[2]}"
DESCRIPTION="${PARAM[3]}"

set -u
