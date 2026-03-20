#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="code"
DATA_DIR="$HOME/.local/share/code"
mkdir -p "$DATA_DIR"

# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# code — Analyze source code for complexity, quality, and structure. 
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_count() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME count <dir>"
    find "${2:-.}" -type f \( -name '*.py' -o -name '*.js' -o -name '*.sh' -o -name '*.go' -o -name '*.rs' \) | xargs wc -l 2>/dev/null
}

cmd_todo() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME todo <dir>"
    grep -rn 'TODO\|FIXME\|HACK\|XXX' "${2:-.}" --include='*.py' --include='*.js' --include='*.sh' 2>/dev/null
}

cmd_functions() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME functions <file>"
    grep -n '^def \|^function \|^func \|cmd_\|^[a-z_]*()' "$2" 2>/dev/null
}

cmd_imports() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME imports <file>"
    grep -n '^import \|^from \|^require\|^use ' "$2" 2>/dev/null
}

cmd_complexity() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME complexity <file>"
    awk '/^(def |function |func )/{n++} END{print n" functions"}' "$2" 2>/dev/null
}

cmd_dupes() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME dupes <dir>"
    find "${2:-.}" -type f -name '*.py' -o -name '*.js' | xargs md5sum 2>/dev/null | sort | uniq -w32 -d
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-20s %s\n" "count <dir>" ""
    printf "  %-20s %s\n" "todo <dir>" ""
    printf "  %-20s %s\n" "functions <file>" ""
    printf "  %-20s %s\n" "imports <file>" ""
    printf "  %-20s %s\n" "complexity <file>" ""
    printf "  %-20s %s\n" "dupes <dir>" ""
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
        count) shift; cmd_count "$@" ;;
        todo) shift; cmd_todo "$@" ;;
        functions) shift; cmd_functions "$@" ;;
        imports) shift; cmd_imports "$@" ;;
        complexity) shift; cmd_complexity "$@" ;;
        dupes) shift; cmd_dupes "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown command: $cmd (try help)" ;;
    esac
}

main "$@"
