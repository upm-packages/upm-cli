
#!/bin/bash

cat << __USAGE__
Usage: ${PROGNAME} add package <package_name> <version>
  Add package into Packages/manifest.json and Assets/package.json

Note:
  Launch interactive shell if parameters are not specified.

Parameters:
  package_name    Name of package (FQDN format)
  version         Version number (SemVer format)

Options:
  -h, --help    Show usage.
__USAGE__
exit 0
