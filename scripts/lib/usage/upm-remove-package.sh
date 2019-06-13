
#!/bin/bash

cat << __USAGE__
Usage: ${PROGNAME} remove package <package_name> <version>
  Remove package from Packages/manifest.json and Assets/package.json

Note:
  Launch interactive shell if parameters are not specified.

Parameters:
  package_name    Name of package (FQDN format)

Options:
  -h, --help    Show usage.
__USAGE__
exit 0
