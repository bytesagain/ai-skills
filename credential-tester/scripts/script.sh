#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="credential-tester"
DATA_DIR="$HOME/.local/share/credential-tester"
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

cmd_http() {
    local url="${2:-}"
    local user="${3:-}"
    local pass="${4:-}"
    [ -z "$url" ] && die "Usage: $SCRIPT_NAME http <url user pass>"
    curl -su $3:$4 -o /dev/null -w '%{http_code}' $2 2>/dev/null
}

cmd_ssh() {
    local host="${2:-}"
    local user="${3:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME ssh <host user>"
    ssh -o ConnectTimeout=5 -o BatchMode=yes $3@$2 exit 2>/dev/null && echo 'OK' || echo 'FAIL'
}

cmd_check_env() {
    echo 'Checking env vars...'; for v in API_KEY TOKEN SECRET; do [ -n "$(eval echo \${$v:-})" ] && echo "$v: set" || echo "$v: not set"; done
}

cmd_report() {
    echo '=== Credential Test Report ===' && date
}

cmd_ports() {
    local host="${2:-}"
    [ -z "$host" ] && die "Usage: $SCRIPT_NAME ports <host>"
    for p in 22 80 443; do (echo >/dev/tcp/$2/$p) 2>/dev/null && echo 'OPEN $2:$p' || echo 'CLOSED $2:$p'; done
}

cmd_validate() {
    local token="${2:-}"
    [ -z "$token" ] && die "Usage: $SCRIPT_NAME validate <token>"
    [ ${#2} -ge 20 ] && echo 'Token length OK' || echo 'Token too short'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "http <url user pass>"
    printf "  %-25s\n" "ssh <host user>"
    printf "  %-25s\n" "check-env"
    printf "  %-25s\n" "report"
    printf "  %-25s\n" "ports <host>"
    printf "  %-25s\n" "validate <token>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        http) shift; cmd_http "$@" ;;
        ssh) shift; cmd_ssh "$@" ;;
        check-env) shift; cmd_check_env "$@" ;;
        report) shift; cmd_report "$@" ;;
        ports) shift; cmd_ports "$@" ;;
        validate) shift; cmd_validate "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
