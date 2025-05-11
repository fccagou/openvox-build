#!/usr/bin/bash
# vim ts=2 sw=2 expandtab

set -euo pipefail

info () {
	printf -- "[*] %s\n" "$@"
}
warning () {
	printf -- "[!] %s\n" "$@"
}
error () {
	printf -- "[-] %s\n" "$@"
}
action () {
	printf -- "[+] %s\n" "$@"
}

prefix="$(readlink -f "$(dirname "$0")")"
BUILDDIR="${BUILDDIR:-"$prefix"/build}"

RUBY="$(readlink -f "${RUBY:-$(which ruby)}")"
RUBY_VERSION="$("$RUBY" --version | awk '{print $2}')"
GEM_HOME="${GEM_HOME:-"$prefix"/cache/"${RUBY_VERSION}"}"
BUNDLE="$(readlink -f "${BUNDLE:-$(which bundle)}")"

VANAGON_WORKDIR="${VANAGON_WORKDIR:-"$prefix"/cache/workdir}"
VANAGON_ENGINE="${VANAGON_ENGINE:-docker}"
VANAGON_PLATFORM="${VANAGON_PLATFORM:-el-9-x86_64}"

VANAGON_RETRY_COUNT="${VANAGON_RETRY_COUNT:-3}"

info "Building openvox"
info "        RUBY: $RUBY"
info "RUBY_VERSION: ${RUBY_VERSION}"
info "    GEM_HOME: ${GEM_HOME}"
info "    BUILDDIR: ${BUILDDIR}"
info "      BUNDLE: $BUNDLE ($("$BUNDLE" version))"

info "    GEMS SYS: $("$RUBY" -e 'puts Gem.default_dir')"
info "   GEMS USER: $("$RUBY" -e 'puts Gem.user_dir')"



[ -d "${GEM_HOME}" ] || mkdir -p "${GEM_HOME}"
[ -d "${BUILDDIR}" ] || mkdir -p "${BUILDDIR}"
[ -d "${VANAGON_WORKDIR}" ] || mkdir -p "${VANAGON_WORKDIR}"

export GEM_HOME
export VANAGON_RETRY_COUNT

# clone puppet-runtimea
[ -d "$BUILDDIR"/puppet-runtime ] \
	|| git clone https://github.com/openvoxproject/puppet-runtime "$BUILDDIR"/puppet-runtime

cd "$BUILDDIR"/puppet-runtime
"$BUNDLE" config set --path "$GEM_HOME"
"$BUNDLE" install
"$BUNDLE" exec vanagon build \
	--verbose \
	--preserve always \
	--engine "${VANAGON_ENGINE}" \
	--workdir "${VANAGON_WORKDIR}" \
	agent-runtime-main "${VANAGON_PLATFORM}"

#
