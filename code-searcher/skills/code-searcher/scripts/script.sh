#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="code-searcher"
DATA_DIR="$HOME/.local/share/code-searcher"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_find() {
    local pattern="${2:-}"
    local dir="${3:-}"
    [ -z "$pattern" ] && die "Usage: $SCRIPT_NAME find <pattern dir>"
    grep -rn --include='*.py' --include='*.js' --include='*.sh' --include='*.go' $2 ${3:-.} 2>/dev/null | head -30
}

cmd_todo() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME todo <dir>"
    grep -rn 'TODO\|FIXME\|HACK\|XXX' ${2:-.} --include='*.py' --include='*.js' --include='*.sh' 2>/dev/null | head -20
}

cmd_refs() {
    local symbol="${2:-}"
    local dir="${3:-}"
    [ -z "$symbol" ] && die "Usage: $SCRIPT_NAME refs <symbol dir>"
    grep -rn $2 ${3:-.} 2>/dev/null | head -20
}

cmd_stats() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME stats <dir>"
    echo 'Files:'; find ${2:-.} -type f -name '*.py' -o -name '*.js' -o -name '*.sh' | wc -l; echo 'Lines:'; find ${2:-.} -type f \( -name '*.py' -o -name '*.js' -o -name '*.sh' \) -exec cat {} + 2>/dev/null | wc -l
}

cmd_recent() {
    local dir="${2:-}"
    local days="${3:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME recent <dir days>"
    find ${2:-.} -type f -mtime -${3:-7} \( -name '*.py' -o -name '*.js' -o -name '*.sh' \) | head -20
}

cmd_grep() {
    local text="${2:-}"
    local dir="${3:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME grep <text dir>"
    grep -rn $2 ${3:-.} 2>/dev/null | head -30
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "find <pattern dir>"
    printf "  %-25s\n" "todo <dir>"
    printf "  %-25s\n" "refs <symbol dir>"
    printf "  %-25s\n" "stats <dir>"
    printf "  %-25s\n" "recent <dir days>"
    printf "  %-25s\n" "grep <text dir>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        find) shift; cmd_find "$@" ;;
        todo) shift; cmd_todo "$@" ;;
        refs) shift; cmd_refs "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        recent) shift; cmd_recent "$@" ;;
        grep) shift; cmd_grep "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
