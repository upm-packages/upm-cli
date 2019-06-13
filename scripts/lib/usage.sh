#!/bin/bash

if [[ -z "${COMMAND}" ]]; then
  source "${DIRECTORY}/scripts/usage/upm.sh"
fi

if [ ${HELP} -eq 1 ]; then
  if [[ -z "${COMMAND}" ]]; then
    source "${DIRECTORY}/scripts/usage/upm.sh"
  fi

  case "${COMMAND}" in
    'init' )
      source "${DIRECTORY}/scripts/usage/upm-init.sh"
      ;;
    'add' )
      case "${SUBCOMMAND}" in
        'registry' )
          source "${DIRECTORY}/scripts/usage/upm-add-registry.sh"
          ;;
        'package' )
          source "${DIRECTORY}/scripts/usage/upm-add-package.sh"
          ;;
        * )
          source "${DIRECTORY}/scripts/usage/upm-add.sh"
          ;;
      esac
      ;;
  esac
fi
