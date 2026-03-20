#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="shell"
DATA_DIR="$HOME/.local/share/shell"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_lint() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME lint <file>"
    shellcheck "$2" 2>/dev/null || { echo "shellcheck not found, basic checks:"; grep -n "\$[a-zA-Z]" "$2" | grep -v '"\$' | head -10 && echo "(unquoted variables?)"; }
}

cmd_functions() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME functions <file>"
    grep -n "^[a-zA-Z_][a-zA-Z0-9_]*()\|^function " "$2"
}

cmd_stats() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME stats <file>"
    echo "Lines: $(wc -l < "$2")"; echo "Functions: $(grep -c "^[a-zA-Z_].*()\|^function " "$2" 2>/dev/null)"; echo "Comments: $(grep -c "^\s*#" "$2" 2>/dev/null)"; echo "Blank: $(grep -c "^\s*$" "$2" 2>/dev/null)"
}

cmd_explain() {
    local cmd="${2:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME explain <cmd>"
    type "$2" 2>/dev/null; which "$2" 2>/dev/null; man -f "$2" 2>/dev/null | head -3
}

cmd_benchmark() {
    local cmd="${2:-}"
    local count="${3:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME benchmark <cmd count>"
    shift; local n="${3:-10}"; local start=$(date +%s%N); for i in $(seq 1 $n); do eval "$2" >/dev/null 2>&1; done; local end=$(date +%s%N); echo "$(( (end-start)/1000000 ))ms for $n runs"
}

cmd_aliases() {
    alias 2>/dev/null | sort
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "lint <file>" ""
    printf "  %-25s %s\n" "functions <file>" ""
    printf "  %-25s %s\n" "stats <file>" ""
    printf "  %-25s %s\n" "explain <cmd>" ""
    printf "  %-25s %s\n" "benchmark <cmd count>" ""
    printf "  %-25s %s\n" "aliases" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        lint) shift; cmd_lint "$@" ;;
        functions) shift; cmd_functions "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        explain) shift; cmd_explain "$@" ;;
        benchmark) shift; cmd_benchmark "$@" ;;
        aliases) shift; cmd_aliases "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
