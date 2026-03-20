#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="chain"
DATA_DIR="$HOME/.local/share/chain"
mkdir -p "$DATA_DIR"

# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# chain — Build and run named command chains with logging and status t
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_create() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME create <name>"
    mkdir -p "$DATA_DIR/chains" && echo '[]' > "$DATA_DIR/chains/$2.json" && echo 'Created chain: $2'
}

cmd_add() {
    local name="${2:-}"
    local cmd="${3:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME add <name cmd>"
    echo "$3" >> "$DATA_DIR/chains/$2.steps" && echo 'Added step to $2'
}

cmd_run() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME run <name>"
    echo "Running chain: $2"; while IFS= read -r step; do echo ">>> $step"; bash -c "$step" || echo 'FAILED'; done < "$DATA_DIR/chains/$2.steps"
}

cmd_list() {
    ls "$DATA_DIR/chains/"*.steps 2>/dev/null | sed 's|.*/||;s|\.steps$||' || echo 'No chains'
}

cmd_show() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME show <name>"
    cat -n "$DATA_DIR/chains/$2.steps" 2>/dev/null || echo 'Chain not found'
}

cmd_remove() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME remove <name>"
    rm -f "$DATA_DIR/chains/$2.steps" "$DATA_DIR/chains/$2.json" && echo 'Removed: $2'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "create <name>" ""
    printf "  %-20s %s\n" "add <name cmd>" ""
    printf "  %-20s %s\n" "run <name>" ""
    printf "  %-20s %s\n" "list" ""
    printf "  %-20s %s\n" "show <name>" ""
    printf "  %-20s %s\n" "remove <name>" ""
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
        create) shift; cmd_create "$@" ;;
        add) shift; cmd_add "$@" ;;
        run) shift; cmd_run "$@" ;;
        list) shift; cmd_list "$@" ;;
        show) shift; cmd_show "$@" ;;
        remove) shift; cmd_remove "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
