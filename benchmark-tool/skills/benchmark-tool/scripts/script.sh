#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="benchmark-tool"
DATA_DIR="$HOME/.local/share/benchmark-tool"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_cpu() {
    echo 'CPU benchmark...'; time echo 'scale=5000; 4*a(1)' | bc -l >/dev/null 2>&1 && echo Done || echo 'bc not available'
}

cmd_memory() {
    free -h && echo '---' && cat /proc/meminfo | head -5
}

cmd_disk() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME disk <dir>"
    dd if=/dev/zero of=${2:-/tmp}/bench_test bs=1M count=100 oflag=direct 2>&1 | tail -1; rm -f ${2:-/tmp}/bench_test
}

cmd_network() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME network <host>"
    curl -so /dev/null -w 'DNS: %{time_namelookup}s Connect: %{time_connect}s Total: %{time_total}s
' ${2:-https://google.com}
}

cmd_all() {
    cmd_cpu; echo '==='; cmd_memory; echo '==='; cmd_disk
}

cmd_compare() {
    local f1="${2:-}"
    local f2="${3:-}"
    [ -z "$f1" ] && die "Usage: $SCRIPT_NAME compare <f1 f2>"
    diff $2 $3
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "cpu"
    printf "  %-25s\n" "memory"
    printf "  %-25s\n" "disk <dir>"
    printf "  %-25s\n" "network <host>"
    printf "  %-25s\n" "all"
    printf "  %-25s\n" "compare <f1 f2>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        cpu) shift; cmd_cpu "$@" ;;
        memory) shift; cmd_memory "$@" ;;
        disk) shift; cmd_disk "$@" ;;
        network) shift; cmd_network "$@" ;;
        all) shift; cmd_all "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
