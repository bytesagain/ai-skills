#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="git"
DATA_DIR="$HOME/.local/share/git"
mkdir -p "$DATA_DIR"

# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# git — Analyze git repositories with commit stats and branch tools.
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_log() {
    local n="${2:-}"
    [ -z "$n" ] && die "Usage: $SCRIPT_NAME log <n>"
    git log --oneline -"${2:-10}"
}

cmd_stats() {
    git shortlog -sn --all 2>/dev/null
}

cmd_branches() {
    git branch -a 2>/dev/null
}

cmd_diff_stat() {
    git diff --stat 2>/dev/null
}

cmd_stale() {
    local days="${2:-}"
    [ -z "$days" ] && die "Usage: $SCRIPT_NAME stale <days>"
    git branch --sort=-committerdate | head -20
}

cmd_size() {
    git count-objects -vH 2>/dev/null
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "log <n>" ""
    printf "  %-20s %s\n" "stats" ""
    printf "  %-20s %s\n" "branches" ""
    printf "  %-20s %s\n" "diff-stat" ""
    printf "  %-20s %s\n" "stale <days>" ""
    printf "  %-20s %s\n" "size" ""
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
        log) shift; cmd_log "$@" ;;
        stats) shift; cmd_stats "$@" ;;
        branches) shift; cmd_branches "$@" ;;
        diff-stat) shift; cmd_diff_stat "$@" ;;
        stale) shift; cmd_stale "$@" ;;
        size) shift; cmd_size "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
