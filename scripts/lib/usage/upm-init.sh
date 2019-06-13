#!/bin/bash

cat << __USAGE__
Usage: ${PROGNAME} init <registry_name> <project_name> <display_name> [<description>]
  Initialize Unity project for Unity Package Manager

Note:
  Launch interactive shell if parameters are not specified.

Parameters:
  registry_name   Name of registry configured in ~/.upm-config.json
  project_name    Name of project
  display_name    Name what displayed in Unity Package Manager UI
  description     Description of package

Options:
  -h, --help    Show usage.
__USAGE__
exit 0
