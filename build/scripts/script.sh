#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="build"
DATA_DIR="$HOME/.local/share/build"
mkdir -p "$DATA_DIR"

# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# build — Compile, build, and package projects with multi-language sup
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_detect() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME detect <dir>"
    for f in Makefile CMakeLists.txt build.gradle pom.xml package.json go.mod Cargo.toml; do [ -f "${2:-.}/$f" ] && echo "Found: $f"; done
}

cmd_make() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME make <dir>"
    cd "${2:-.}" && make 2>&1
}

cmd_clean() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME clean <dir>"
    cd "${2:-.}" && make clean 2>&1 || find . -name '*.o' -delete
}

cmd_deps() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME deps <dir>"
    find "${2:-.}" -maxdepth 2 \( -name 'requirements.txt' -o -name 'package.json' -o -name 'go.sum' \) -exec echo {} \;
}

cmd_size() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME size <dir>"
    du -sh "${2:-.}" | cut -f1
}

cmd_artifacts() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME artifacts <dir>"
    find "${2:-.}" -name '*.jar' -o -name '*.whl' -o -name '*.tar.gz' -o -name '*.deb' 2>/dev/null
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "detect <dir>" ""
    printf "  %-20s %s\n" "make <dir>" ""
    printf "  %-20s %s\n" "clean <dir>" ""
    printf "  %-20s %s\n" "deps <dir>" ""
    printf "  %-20s %s\n" "size <dir>" ""
    printf "  %-20s %s\n" "artifacts <dir>" ""
    printf "  %-20s %s\n" "help" "Show this help"
    printf "  %-20s %s\n" "version" "Show version"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() {
    echo "$SCRIPT_NAME v$VERSION"
}

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        detect) shift; cmd_detect "$@" ;;
        make) shift; cmd_make "$@" ;;
        clean) shift; cmd_clean "$@" ;;
        deps) shift; cmd_deps "$@" ;;
        size) shift; cmd_size "$@" ;;
        artifacts) shift; cmd_artifacts "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
