# Command Line Interface for Unity Package Manager

## Summary

Provide commands to init or modify project using cli.

## Installation

```bash
bash <(curl -sL https://raw.githubusercontent.com/upm-packages/upm-cli/master/scripts/install-latest-release.sh)
```

**Notice**: This command creates a symbolic link to `/usr/local/bin/upm`

## Requirements

* macOS Mojave
* [Unity](https://unity.com/) 2019.1 or higher
* [jq](https://stedolan.github.io/jq/)
* [git](https://git-scm.com/)

## Requirements for Development

* [bats](https://github.com/sstephenson/bats)
    * [bats-support](https://github.com/ztombol/bats-support)
    * [bats-assert](https://github.com/ztombol/bats-assert)
    * [bats-file](https://github.com/peshay/bats-file)

```bash
brew install bats

npm i -g -D https://github.com/ztombol/bats-support
npm i -g -D https://github.com/ztombol/bats-assert
npm i -g -D https://github.com/peshay/bats-file
```

## Configuration

Put configuration file like as below to `~/.upm-config.json`

```json
{
  "registries": {
    "upm-packages.dev": {
      "name": "Unofficial Unity Package Manager Registry",
      "protocol": "https",
      "hostname": "upm-packages.dev",
      "scopes": [
        "dev.monry.upm"
      ],
      "unity_version": "2019.1",
      "author": {
        "name": "Tetsuya Mori",
        "url": "https://me.monry.dev/",
        "email": "monry@example.com"
      },
      "license": "MIT",
      "repository": {
        "type": "git",
        "user": "monry",
        "organization": ""
      },
      "domain": "dev.monry.upm"
    }
  }
}
```

The following parameters are used when initialize a package project using `upm init`.
Please be sure to rewrite the package author.

* `author`
* `license`
* `repository`
* `domain`

## Usage

All commands will launch interactive shell if parameters are not specified.

### `upm help [command] [subcommand]`

Show usages.

```bash
upm help
```

### `upm init`

Initialize project as upm package.

```bash
upm init <registry_name> <project_name> <display_name> [<description>]
```

| Name | Description |
| --- | --- |
| registry_name | Name of registry configured in `~/.upm-config.json` |
| project_name | Name of project |
| display_name | Name what displayed in Unity Package Manager UI |
| description | Description of package |

### `upm add registry`

Add registry configuration into `Packages/manifest.json`.

```bash
upm add registry <registry_name>
```

| Name | Description |
| --- | --- |
| registry_name | Name of registry configured in `~/.upm-config.json` |

### `upm add package`

Add package dependency into `Packages/manifest.json` and `Assets/package.json`.

```bash
upm add package <package_id> <package_version>
```

| Name | Description |
| --- | --- |
| package_id | Full qualified package name (ex: `dev.monry.upm.some-package`) |
| package_version | Version of package |

### `upm remove package`

Remove package dependency from `Packages/manifest.json` and `Assets/package.json`.

```bash
upm remove package <package_id>
```

| Name | Description |
| --- | --- |
| package_id | Full qualified package name (ex: `dev.monry.upm.some-package`) |

## License

Copyright &copy; 2019 Tetsuya Mori

Released under the MIT license, see [LICENSE.txt](LICENSE.txt)
