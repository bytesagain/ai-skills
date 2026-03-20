#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="node"
DATA_DIR="$HOME/.local/share/node"
mkdir -p "$DATA_DIR"

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_deps() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME deps <dir>"
    cat "${2:-.}/package.json" 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);[print(k,v) for k,v in d.get("dependencies",{}).items()]" 2>/dev/null
}

cmd_scripts() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME scripts <dir>"
    cat "${2:-.}/package.json" 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);[print(k,":",v) for k,v in d.get("scripts",{}).items()]" 2>/dev/null
}

cmd_outdated() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME outdated <dir>"
    cd "${2:-.}" && npm outdated 2>/dev/null || echo "npm not available"
}

cmd_audit() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME audit <dir>"
    cd "${2:-.}" && npm audit --json 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);print(json.dumps(d.get("metadata",{}),indent=2))" 2>/dev/null || echo "npm not available"
}

cmd_size() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME size <dir>"
    du -sh "${2:-.}/node_modules" 2>/dev/null || echo "No node_modules"
}

cmd_clean() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME clean <dir>"
    rm -rf "${2:-.}/node_modules" && echo "Cleaned node_modules"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "deps <dir>" ""
    printf "  %-25s %s\n" "scripts <dir>" ""
    printf "  %-25s %s\n" "outdated <dir>" ""
    printf "  %-25s %s\n" "audit <dir>" ""
    printf "  %-25s %s\n" "size <dir>" ""
    printf "  %-25s %s\n" "clean <dir>" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        deps) shift; cmd_deps "$@" ;;
        scripts) shift; cmd_scripts "$@" ;;
        outdated) shift; cmd_outdated "$@" ;;
        audit) shift; cmd_audit "$@" ;;
        size) shift; cmd_size "$@" ;;
        clean) shift; cmd_clean "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
