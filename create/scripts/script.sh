#!/usr/bin/env bash
set -euo pipefail

VERSION="1.0.0"
SCRIPT_NAME="create"
DATA_DIR="$HOME/.local/share/create"
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
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_project() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME project <name>"
    mkdir -p "$2"/{src,tests,docs} && echo "# $2" > "$2/README.md" && echo "Created project: $2"
}

cmd_config() {
    local type="${2:-}"
    local name="${3:-}"
    [ -z "$type" ] && die "Usage: $SCRIPT_NAME config <type name>"
    case "$2" in json) echo "{}" > "$3.json";; yaml) echo "---" > "$3.yaml";; env) echo "# env" > "$3.env";; esac && echo "Created"
}

cmd_script() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME script <name>"
    echo "#!/usr/bin/env bash" > "$2" && echo "set -euo pipefail" >> "$2" && chmod +x "$2" && echo "Created: $2"
}

cmd_readme() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME readme <name>"
    echo "# $2" > README.md && echo "Created README.md"
}

cmd_gitignore() {
    local lang="${2:-}"
    [ -z "$lang" ] && die "Usage: $SCRIPT_NAME gitignore <lang>"
    case "$2" in python) echo -e "*.pyc\n__pycache__/";; node) echo "node_modules/";; *) echo ".env";; esac > .gitignore && echo "Created .gitignore"
}

cmd_makefile() {
    local name="${2:-}"
    [ -z "$name" ] && die "Usage: $SCRIPT_NAME makefile <name>"
    printf ".PHONY: build test clean\n\nbuild:\n\t@echo Building\n\ntest:\n\t@echo Testing\n\nclean:\n\t@echo Cleaning\n" > Makefile && echo "Created Makefile"
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "project <name>"
    printf "  %-25s\n" "config <type name>"
    printf "  %-25s\n" "script <name>"
    printf "  %-25s\n" "readme <name>"
    printf "  %-25s\n" "gitignore <lang>"
    printf "  %-25s\n" "makefile <name>"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        project) shift; cmd_project "$@" ;;
        config) shift; cmd_config "$@" ;;
        script) shift; cmd_script "$@" ;;
        readme) shift; cmd_readme "$@" ;;
        gitignore) shift; cmd_gitignore "$@" ;;
        makefile) shift; cmd_makefile "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
