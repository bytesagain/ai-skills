#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="bundle"
DATA_DIR="$HOME/.local/share/bundle"
mkdir -p "$DATA_DIR"

# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# bundle — Package directories into distributable bundles with manifest
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_create() {
    local dir="${2:-}"
    local output="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME create <dir output>"
    tar -czf "$3" "$2" && sha256sum "$3" > "$3.sha256" && echo "Bundle: $3 ($(du -h "$3" | cut -f1))"
}

cmd_manifest() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME manifest <dir>"
    find "$2" -type f -exec sha256sum {} \; 2>/dev/null
}

cmd_verify() {
    local bundle="${2:-}"
    [ -z "$bundle" ] && die "Usage: $SCRIPT_NAME verify <bundle>"
    sha256sum -c "$2.sha256" 2>/dev/null && echo 'VERIFIED' || echo 'FAILED'
}

cmd_size() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME size <dir>"
    du -sh "$2" | cut -f1
}

cmd_list() {
    local bundle="${2:-}"
    [ -z "$bundle" ] && die "Usage: $SCRIPT_NAME list <bundle>"
    tar -tzf "$2" 2>/dev/null
}

cmd_extract() {
    local bundle="${2:-}"
    local dir="${3:-}"
    [ -z "$bundle" ] && die "Usage: $SCRIPT_NAME extract <bundle dir>"
    mkdir -p "${3:-.}" && tar -xzf "$2" -C "${3:-.}" && echo 'Extracted'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "create <dir output>" ""
    printf "  %-20s %s\n" "manifest <dir>" ""
    printf "  %-20s %s\n" "verify <bundle>" ""
    printf "  %-20s %s\n" "size <dir>" ""
    printf "  %-20s %s\n" "list <bundle>" ""
    printf "  %-20s %s\n" "extract <bundle dir>" ""
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
        create) shift; cmd_create "$@" ;;
        manifest) shift; cmd_manifest "$@" ;;
        verify) shift; cmd_verify "$@" ;;
        size) shift; cmd_size "$@" ;;
        list) shift; cmd_list "$@" ;;
        extract) shift; cmd_extract "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
