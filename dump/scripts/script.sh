#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="dump"
DATA_DIR="$HOME/.local/share/dump"
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

cmd_system() {
    uname -a; echo "---"; uptime; echo "---"; free -h; echo "---"; df -h
}

cmd_env() {
    env | sort
}

cmd_network() {
    ip addr 2>/dev/null; echo "---"; ip route 2>/dev/null; echo "---"; cat /etc/resolv.conf 2>/dev/null
}

cmd_processes() {
    local count="${2:-}"
    [ -z "$count" ] && die "Usage: $SCRIPT_NAME processes <count>"
    ps aux --sort=-%mem | head -"${2:-20}"
}

cmd_save() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME save <file>"
    { uname -a; echo "---"; free -h; echo "---"; df -h; } > "$2" && echo "Saved to $2"
}

cmd_packages() {
    rpm -qa 2>/dev/null | wc -l || dpkg -l 2>/dev/null | wc -l
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "system"
    printf "  %-25s\n" "env"
    printf "  %-25s\n" "network"
    printf "  %-25s\n" "processes <count>"
    printf "  %-25s\n" "save <file>"
    printf "  %-25s\n" "packages"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        system) shift; cmd_system "$@" ;;
        env) shift; cmd_env "$@" ;;
        network) shift; cmd_network "$@" ;;
        processes) shift; cmd_processes "$@" ;;
        save) shift; cmd_save "$@" ;;
        packages) shift; cmd_packages "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
