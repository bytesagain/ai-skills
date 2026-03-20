#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="capture"
DATA_DIR="$HOME/.local/share/capture"
mkdir -p "$DATA_DIR"

# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# capture — Capture command output, diffs, and system snapshots for debu
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_command() {
    local cmd="${2:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME command <cmd>"
    bash -c "$2" 2>&1 | tee "$DATA_DIR/capture_$(date +%s).log"
}

cmd_diff() {
    local cmd1="${2:-}"
    local cmd2="${3:-}"
    [ -z "$cmd1" ] && die "Usage: $SCRIPT_NAME diff <cmd1 cmd2>"
    diff <(bash -c "$2" 2>&1) <(bash -c "$3" 2>&1)
}

cmd_env() {
    env | sort > "$DATA_DIR/env_$(date +%s).txt" && echo 'Captured environment'
}

cmd_system() {
    echo "Hostname: $(hostname)"; echo "Kernel: $(uname -r)"; echo "Uptime: $(uptime -p 2>/dev/null || uptime)"; echo "Memory:"; free -h 2>/dev/null; echo "Disk:"; df -h / | tail -1
}

cmd_log() {
    local cmd="${2:-}"
    local file="${3:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME log <cmd file>"
    bash -c "$2" 2>&1 | tee "${3:-$DATA_DIR/capture.log}"
}

cmd_timed() {
    local cmd="${2:-}"
    [ -z "$cmd" ] && die "Usage: $SCRIPT_NAME timed <cmd>"
    time bash -c "$2" 2>&1
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "command <cmd>" ""
    printf "  %-20s %s\n" "diff <cmd1 cmd2>" ""
    printf "  %-20s %s\n" "env" ""
    printf "  %-20s %s\n" "system" ""
    printf "  %-20s %s\n" "log <cmd file>" ""
    printf "  %-20s %s\n" "timed <cmd>" ""
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
        command) shift; cmd_command "$@" ;;
        diff) shift; cmd_diff "$@" ;;
        env) shift; cmd_env "$@" ;;
        system) shift; cmd_system "$@" ;;
        log) shift; cmd_log "$@" ;;
        timed) shift; cmd_timed "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
