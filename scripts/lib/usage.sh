#!/bin/bash

if [[ -z "${COMMAND}" ]]; then
  source "${DIRECTORY}/scripts/lib/usage/upm.sh"
fi

if [ ${HELP} -eq 1 ]; then
  if [[ -z "${COMMAND}" ]]; then
    source "${DIRECTORY}/scripts/lib/usage/upm.sh"
  fi

  case "${COMMAND}" in
    'init' )
      source "${DIRECTORY}/scripts/lib/usage/upm-init.sh"
      ;;
    'add' )
      case "${SUBCOMMAND}" in
        'registry' )
          source "${DIRECTORY}/scripts/lib/usage/upm-add-registry.sh"
          ;;
        'package' )
          source "${DIRECTORY}/scripts/lib/usage/upm-add-package.sh"
          ;;
        * )
          source "${DIRECTORY}/scripts/lib/usage/upm-add.sh"
          ;;
      esac
      ;;
    'remove' )
      case "${SUBCOMMAND}" in
        'package' )
          source "${DIRECTORY}/scripts/lib/usage/upm-remove-package.sh"
          ;;
        * )
          source "${DIRECTORY}/scripts/lib/usage/upm-remove.sh"
          ;;
      esac
      ;;
  esac
fi
