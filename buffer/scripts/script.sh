#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="buffer"
DATA_DIR="$HOME/.local/share/buffer"
mkdir -p "$DATA_DIR"

# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# buffer — Manage a text buffer stack for quick copy-paste operations. 
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_push() {
    local text="${2:-}"
    [ -z "$text" ] && die "Usage: $SCRIPT_NAME push <text>"
    echo "$2" >> "$DATA_DIR/stack.txt" && echo 'Pushed'
}

cmd_pop() {
    tail -1 "$DATA_DIR/stack.txt" 2>/dev/null; sed -i '$ d' "$DATA_DIR/stack.txt" 2>/dev/null
}

cmd_peek() {
    tail -1 "$DATA_DIR/stack.txt" 2>/dev/null || echo 'Empty'
}

cmd_list() {
    cat -n "$DATA_DIR/stack.txt" 2>/dev/null || echo 'Empty'
}

cmd_size() {
    wc -l "$DATA_DIR/stack.txt" 2>/dev/null | awk '{print $1}' || echo '0'
}

cmd_clear() {
    true > "$DATA_DIR/stack.txt" && echo 'Cleared'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "push <text>" ""
    printf "  %-20s %s\n" "pop" ""
    printf "  %-20s %s\n" "peek" ""
    printf "  %-20s %s\n" "list" ""
    printf "  %-20s %s\n" "size" ""
    printf "  %-20s %s\n" "clear" ""
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
        push) shift; cmd_push "$@" ;;
        pop) shift; cmd_pop "$@" ;;
        peek) shift; cmd_peek "$@" ;;
        list) shift; cmd_list "$@" ;;
        size) shift; cmd_size "$@" ;;
        clear) shift; cmd_clear "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
