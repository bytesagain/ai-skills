#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="audit"
DATA_DIR="$HOME/.local/share/audit"
mkdir -p "$DATA_DIR"

# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# audit — Audit system security with user, port, and permission checks
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_users() {
    echo '=== Users with shell ==='; grep -v 'nologin\|false' /etc/passwd | cut -d: -f1,7
}

cmd_ports() {
    ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null
}

cmd_perms() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME perms <dir>"
    find "${2:-.}" -perm -002 -type f 2>/dev/null | head -20; echo '---'; find "${2:-.}" -perm -4000 -type f 2>/dev/null | head -10
}

cmd_ssh() {
    echo '=== SSH Config ==='; grep -E 'PermitRoot|PasswordAuth|Port ' /etc/ssh/sshd_config 2>/dev/null || echo 'Cannot read sshd_config'
}

cmd_firewall() {
    iptables -L -n 2>/dev/null || echo 'Cannot read iptables (need root)'
}

cmd_packages() {
    rpm -qa --last 2>/dev/null | head -20 || dpkg -l 2>/dev/null | tail -20
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "users" ""
    printf "  %-20s %s\n" "ports" ""
    printf "  %-20s %s\n" "perms <dir>" ""
    printf "  %-20s %s\n" "ssh" ""
    printf "  %-20s %s\n" "firewall" ""
    printf "  %-20s %s\n" "packages" ""
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
        users) shift; cmd_users "$@" ;;
        ports) shift; cmd_ports "$@" ;;
        perms) shift; cmd_perms "$@" ;;
        ssh) shift; cmd_ssh "$@" ;;
        firewall) shift; cmd_firewall "$@" ;;
        packages) shift; cmd_packages "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
