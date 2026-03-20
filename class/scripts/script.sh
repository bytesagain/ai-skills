#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="class"
DATA_DIR="$HOME/.local/share/class"
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
#
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_python() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME python <name>"
    echo "class $2:"; echo "    def __init__(self):"; echo "        pass"
}

cmd_java() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME java <name>"
    echo "public class $2 {"; echo "    public $2() {}"; echo "}"
}

cmd_go() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME go <name>"
    echo "type $2 struct {"; echo "    // fields"; echo "}"
}

cmd_typescript() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME typescript <name>"
    echo "class $2 {"; echo "    constructor() {}"; echo "}"
}

cmd_rust() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME rust <name>"
    echo "struct $2 {"; echo "    // fields"; echo "}"
}

cmd_list() {
    echo "Supported: python, java, go, typescript, rust"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "python <name>"
    printf "  %-25s\n" "java <name>"
    printf "  %-25s\n" "go <name>"
    printf "  %-25s\n" "typescript <name>"
    printf "  %-25s\n" "rust <name>"
    printf "  %-25s\n" "list"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        python) shift; cmd_python "$@" ;;
        java) shift; cmd_java "$@" ;;
        go) shift; cmd_go "$@" ;;
        typescript) shift; cmd_typescript "$@" ;;
        rust) shift; cmd_rust "$@" ;;
        list) shift; cmd_list "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
