#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="mail"
DATA_DIR="$HOME/.local/share/mail"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_validate() {
    local email="${2:-}"
    [ -z "$email" ] && die "Usage: $SCRIPT_NAME validate <email>"
    echo "$2" | grep -qP "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" && echo "Valid: $2" || echo "Invalid: $2"
}

cmd_mx() {
    local domain="${2:-}"
    [ -z "$domain" ] && die "Usage: $SCRIPT_NAME mx <domain>"
    dig +short MX "$2" 2>/dev/null || nslookup -type=MX "$2" 2>/dev/null
}

cmd_compose() {
    local to="${2:-}"
    local subject="${3:-}"
    local body="${4:-}"
    [ -z "$to" ] && die "Usage: $SCRIPT_NAME compose <to subject body>"
    printf "To: %s\nSubject: %s\n\n%s\n" "$2" "$3" "$4"
}

cmd_template() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME template <name>"
    cat "$DATA_DIR/templates/$2.txt" 2>/dev/null || die "Template not found: $2"
}

cmd_save_template() {
    local name="${2:-}"
    local text="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME save-template <name text>"
    mkdir -p "$DATA_DIR/templates" && echo "$3" > "$DATA_DIR/templates/$2.txt" && echo "Saved template: $2"
}

cmd_batch_validate() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME batch-validate <file>"
    while IFS= read -r email; do echo "$email" | grep -qP "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" && echo "OK $email" || echo "BAD $email"; done < "$2"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "validate <email>" ""
    printf "  %-25s %s\n" "mx <domain>" ""
    printf "  %-25s %s\n" "compose <to subject body>" ""
    printf "  %-25s %s\n" "template <name>" ""
    printf "  %-25s %s\n" "save-template <name text>" ""
    printf "  %-25s %s\n" "batch-validate <file>" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        validate) shift; cmd_validate "$@" ;;
        mx) shift; cmd_mx "$@" ;;
        compose) shift; cmd_compose "$@" ;;
        template) shift; cmd_template "$@" ;;
        save-template) shift; cmd_save_template "$@" ;;
        batch-validate) shift; cmd_batch_validate "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
