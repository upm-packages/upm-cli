#!/bin/bash

set -ue

latest_version=$( git ls-remote --tags https://github.com/upm-packages/upm-cli.git | sed -nE 's#.*refs/tags/(v?[0-9]+(\.[0-9]+)*(-(alpha|beta|preview)\.?[0-9]*)?)$#\1#p' | sort -Vr | head -n 1 )
name="upm-cli-${latest_version//v/}"
tarball_file="${name}.tar.gz"
mkdir -p ~/.upm
cd ~/.upm
curl -sLo ${tarball_file} https://github.com/upm-packages/upm-cli/archive/${latest_version}.tar.gz
tar zxf ${tarball_file}
rm ${tarball_file}
echo ${latest_version} > "`pwd`/${name}/VERSION.txt"
ln -sf "`pwd`/${name}/upm" /usr/local/bin/upm
