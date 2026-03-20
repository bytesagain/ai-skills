#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="chaos-testing"
DATA_DIR="$HOME/.local/share/chaos-testing"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_cpu_stress() {
    local seconds="${2:-}"
    [ -z "$seconds" ] && die "Usage: $SCRIPT_NAME cpu-stress <seconds>"
    echo 'CPU stress for ${2:-10}s'; timeout ${2:-10} dd if=/dev/urandom of=/dev/null bs=1M 2>/dev/null; echo Done
}

cmd_mem_stress() {
    local mb="${2:-}"
    [ -z "$mb" ] && die "Usage: $SCRIPT_NAME mem-stress <mb>"
    echo 'Allocating ${2:-100}MB'; head -c ${2:-100}m /dev/urandom > /tmp/chaos_mem_test; rm /tmp/chaos_mem_test; echo Done
}

cmd_disk_fill() {
    local mb="${2:-}"
    local dir="${3:-}"
    [ -z "$mb" ] && die "Usage: $SCRIPT_NAME disk-fill <mb dir>"
    dd if=/dev/zero of=${3:-/tmp}/chaos_disk bs=1M count=${2:-100} 2>/dev/null; rm ${3:-/tmp}/chaos_disk; echo Done
}

cmd_io_stress() {
    local seconds="${2:-}"
    [ -z "$seconds" ] && die "Usage: $SCRIPT_NAME io-stress <seconds>"
    echo 'I/O stress for ${2:-10}s'; timeout ${2:-10} dd if=/dev/urandom of=/dev/null bs=4k 2>/dev/null; echo Done
}

cmd_report() {
    echo '=== System After Test ==='; uptime; free -h; df -h / | tail -1
}

cmd_status() {
    uptime && free -h | head -2
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "cpu-stress <seconds>"
    printf "  %-25s\n" "mem-stress <mb>"
    printf "  %-25s\n" "disk-fill <mb dir>"
    printf "  %-25s\n" "io-stress <seconds>"
    printf "  %-25s\n" "report"
    printf "  %-25s\n" "status"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        cpu-stress) shift; cmd_cpu_stress "$@" ;;
        mem-stress) shift; cmd_mem_stress "$@" ;;
        disk-fill) shift; cmd_disk_fill "$@" ;;
        io-stress) shift; cmd_io_stress "$@" ;;
        report) shift; cmd_report "$@" ;;
        status) shift; cmd_status "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
