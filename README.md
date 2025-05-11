# openvox-build

## Description

Make scripts to bootstrap [openvox](https://github.com/OpenVoxProject) building environment.


## Status

Actually **Draft**, it's a way for me to discover [ruby](https://www.ruby-lang.org)
ecosystem and find howto help OpenVoxProject in building process for airgap
network.

## Process

The script except that ruby and bundler are installed, clone each projects and builds them.

## Environment variables

| Var name | Description | Default |
|----------|-------------|---------|
| BUILDDIR | Dir where the script clone projects | "${BUILDDIR:-"$prefix"/build}" |
| RUBY | Path to ruby binary | "$(readlink -f "${RUBY:-$(which ruby)}")" |
| GEM_HOME | Change the default GEM directory | "${GEM_HOME:-"$prefix"/cache/"${RUBY_VERSION}"}" |
| BUNDLE | Path to bundle binary | "$(readlink -f "${BUNDLE:-$(which bundle)}")" |
| VANAGON_WORKDIR | Dir used by vanagon to make the set of data used for building process (src, scripts, patches ...) | "${VANAGON_WORKDIR:-"$prefix"/cache/workdir}" |
| VANAGON_ENGINE | Vanagon engine _(see vanagon --help)_ | "${VANAGON_ENGINE:-docker}" |
| VANAGON_PLATFORM | Vanagon platform _(see vanagon --help)_ | "${VANAGON_PLATFORM:-el-9-x86_64}" |
| VANAGON_RETRY_COUNT | Number of retries for downloads| "${VANAGON_RETRY_COUNT:-3}" |


## Projects built

The first built project is [puppet-runtime](https://github.com/OpenVoxProject/puppet-runtime) used by all projects building
process.




