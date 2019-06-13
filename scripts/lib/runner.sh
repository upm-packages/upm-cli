#!/bin/bash

set +u

case "${COMMAND}" in
  'init' )
    source "${DIRECTORY}/scripts/upm-init.sh" "${PARAM[@]}"
    ;;
  'add' )
    case "${SUBCOMMAND}" in
      'registry' )
        source "${DIRECTORY}/scripts/upm-add-registry.sh" "${PARAM[@]}"
        ;;
      'package' )
        source "${DIRECTORY}/scripts/upm-add-package.sh" "${PARAM[@]}"
        ;;
    esac
    ;;
esac

set -u