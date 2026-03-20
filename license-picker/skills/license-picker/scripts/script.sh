#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="license-picker"
DATA_DIR="$HOME/.local/share/license-picker"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_list() {
    echo 'Available: MIT, Apache-2.0, GPL-3.0, BSD-2, BSD-3, ISC, MPL-2.0, Unlicense'
}

cmd_info() {
    local license="${2:-}"
    [ -z "$license" ] && die "Usage: $SCRIPT_NAME info <license>"
    case $2 in MIT) echo 'MIT: Permissive, commercial use OK, must include license';; Apache-2.0) echo 'Apache 2.0: Permissive, patent grant, must include license+notice';; GPL-3.0) echo 'GPL 3.0: Copyleft, derivative works must be GPL';; *) echo 'License $2: check choosealicense.com';; esac
}

cmd_create() {
    local license="${2:-}"
    local author="${3:-}"
    [ -z "$license" ] && die "Usage: $SCRIPT_NAME create <license author>"
    echo 'MIT License

Copyright (c) '$(date +%Y)' '$3'

Permission is hereby granted...' > LICENSE && echo 'Created LICENSE'
}

cmd_compare() {
    local l1="${2:-}"
    local l2="${3:-}"
    [ -z "$l1" ] && die "Usage: $SCRIPT_NAME compare <l1 l2>"
    echo '=== $2 vs $3 ==='; cmd_info $2; echo '---'; cmd_info $3
}

cmd_recommend() {
    local use="${2:-}"
    [ -z "$use" ] && die "Usage: $SCRIPT_NAME recommend <use>"
    case $2 in commercial) echo 'Recommended: MIT or Apache-2.0';; opensource) echo 'Recommended: GPL-3.0 or AGPL-3.0';; *) echo 'Recommended: MIT (most permissive)';; esac
}

cmd_detect() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME detect <file>"
    grep -li 'MIT\|Apache\|GPL\|BSD' ${2:-LICENSE} 2>/dev/null || echo 'No license detected'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "list"
    printf "  %-25s\n" "info <license>"
    printf "  %-25s\n" "create <license author>"
    printf "  %-25s\n" "compare <l1 l2>"
    printf "  %-25s\n" "recommend <use>"
    printf "  %-25s\n" "detect <file>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        list) shift; cmd_list "$@" ;;
        info) shift; cmd_info "$@" ;;
        create) shift; cmd_create "$@" ;;
        compare) shift; cmd_compare "$@" ;;
        recommend) shift; cmd_recommend "$@" ;;
        detect) shift; cmd_detect "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
