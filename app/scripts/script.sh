#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="app"
DATA_DIR="$HOME/.local/share/app"
mkdir -p "$DATA_DIR"

# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# app — Scaffold, build, and manage application projects locally. Us
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_init() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME init <name>"
    mkdir -p "$2/src" "$2/tests" && echo '{"name":"'"$2"'"}' > "$2/package.json" && echo "Created $2"
}

cmd_tree() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME tree <dir>"
    find "${2:-.}" -not -path '*/.git/*' | head -50 | sed 's|[^/]*/|  |g'
}

cmd_size() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME size <dir>"
    du -sh "${2:-.}" 2>/dev/null | cut -f1
}

cmd_deps() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME deps <dir>"
    find "${2:-.}" -name 'package.json' -o -name 'requirements.txt' -o -name 'go.mod' | head -10
}

cmd_clean() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME clean <dir>"
    find "${2:-.}" -name 'node_modules' -o -name '__pycache__' -o -name '.cache' | head -20
}

cmd_lines() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME lines <dir>"
    find "${2:-.}" -name '*.py' -o -name '*.js' -o -name '*.sh' | xargs wc -l 2>/dev/null | tail -1
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "init <name>" ""
    printf "  %-20s %s\n" "tree <dir>" ""
    printf "  %-20s %s\n" "size <dir>" ""
    printf "  %-20s %s\n" "deps <dir>" ""
    printf "  %-20s %s\n" "clean <dir>" ""
    printf "  %-20s %s\n" "lines <dir>" ""
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
        init) shift; cmd_init "$@" ;;
        tree) shift; cmd_tree "$@" ;;
        size) shift; cmd_size "$@" ;;
        deps) shift; cmd_deps "$@" ;;
        clean) shift; cmd_clean "$@" ;;
        lines) shift; cmd_lines "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
