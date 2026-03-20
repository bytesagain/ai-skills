#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="test"
DATA_DIR="$HOME/.local/share/test"
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

cmd_assert() {
    local expected="${2:-}"
    local actual="${3:-}"
    [ -z "$expected" ] && die "Usage: $SCRIPT_NAME assert <expected actual>"
    [ "$2" = "$3" ] && echo "PASS: $2 == $3" || { echo "FAIL: expected=$2 actual=$3"; exit 1; }
}

cmd_assert_file() {
    local f1="${2:-}"
    local f2="${3:-}"
    [ -z "$f1" ] && die "Usage: $SCRIPT_NAME assert-file <f1 f2>"
    diff -q "$2" "$3" >/dev/null && echo "PASS: files match" || { echo "FAIL: files differ"; diff "$2" "$3" | head -10; exit 1; }
}

cmd_assert_exit() {
    local code="${2:-}"
    local cmd="${3:-}"
    [ -z "$code" ] && die "Usage: $SCRIPT_NAME assert-exit <code cmd>"
    shift 2; eval "$@"; local rc=$?; [ "$rc" -eq "$2" ] && echo "PASS: exit=$rc" || { echo "FAIL: expected=$2 got=$rc"; exit 1; }
}

cmd_run() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME run <dir>"
    local pass=0 fail=0; for f in "$2"/test_*.sh; do [ -f "$f" ] || continue; if bash "$f" >/dev/null 2>&1; then pass=$((pass+1)); echo "PASS $f"; else fail=$((fail+1)); echo "FAIL $f"; fi; done; echo "---"; echo "$pass passed, $fail failed"
}

cmd_coverage() {
    local dir="${2:-}"
    [ -z "$dir" ] && die "Usage: $SCRIPT_NAME coverage <dir>"
    find "$2" -name "*.sh" | while read f; do local funcs=$(grep -c "^[a-zA-Z_].*()" "$f" 2>/dev/null); local tests=$(find "$2" -name "test_*" | xargs grep -l "$(basename $f)" 2>/dev/null | wc -l); echo "$f: $funcs funcs, $tests test files"; done
}

cmd_report() {
    local logfile="${2:-}"
    [ -z "$logfile" ] && die "Usage: $SCRIPT_NAME report <logfile>"
    grep -c PASS "$2" 2>/dev/null; grep -c FAIL "$2" 2>/dev/null
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s %s\n" "assert <expected actual>" ""
    printf "  %-25s %s\n" "assert-file <f1 f2>" ""
    printf "  %-25s %s\n" "assert-exit <code cmd>" ""
    printf "  %-25s %s\n" "run <dir>" ""
    printf "  %-25s %s\n" "coverage <dir>" ""
    printf "  %-25s %s\n" "report <logfile>" ""
    printf "  %-25s %s\n" "help" "Show this help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        assert) shift; cmd_assert "$@" ;;
        assert-file) shift; cmd_assert_file "$@" ;;
        assert-exit) shift; cmd_assert_exit "$@" ;;
        run) shift; cmd_run "$@" ;;
        coverage) shift; cmd_coverage "$@" ;;
        report) shift; cmd_report "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
