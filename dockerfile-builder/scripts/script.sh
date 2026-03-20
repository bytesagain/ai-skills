#!/usr/bin/env bash
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="dockerfile-builder"
DATA_DIR="$HOME/.local/share/dockerfile-builder"
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
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

_info()  { echo "[INFO]  $*"; }
_error() { echo "[ERROR] $*" >&2; }
die()    { _error "$@"; exit 1; }

cmd_create() {
    local language="${2:-}"
    [ -z "$language" ] && die "Usage: $SCRIPT_NAME create <language>"
    case $2 in python) echo 'FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python","app.py"]';; node) echo 'FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
CMD ["node","index.js"]';; go) echo 'FROM golang:1.22-alpine
WORKDIR /app
COPY . .
RUN go build -o main .
CMD ["./main"]';; *) echo 'Unknown language: $2';; esac
}

cmd_lint() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME lint <file>"
    grep -n 'latest' $2 && echo 'WARN: Avoid :latest tag'; grep -c RUN $2 | awk '{if($1>5) print "WARN: Too many RUN layers"}'
}

cmd_optimize() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME optimize <file>"
    echo '=== Optimization suggestions for $2 ==='; grep -c RUN $2 | awk '{if($1>3) print "Combine RUN commands"}'
}

cmd_template() {
    local type="${2:-}"
    [ -z "$type" ] && die "Usage: $SCRIPT_NAME template <type>"
    case $2 in multi-stage) echo 'FROM node:20 AS build
WORKDIR /app
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html';; *) echo 'Unknown type';; esac
}

cmd_scan() {
    local file="${2:-}"
    [ -z "$file" ] && die "Usage: $SCRIPT_NAME scan <file>"
    echo 'Scanning $2...'; grep -in 'password\|secret\|key' $2 && echo 'WARN: Potential secrets' || echo 'Clean'
}

cmd_list() {
    echo 'Supported: python, node, go, multi-stage'
}

cmd_help() {
    echo "$SCRIPT_NAME v$VERSION"
    echo ""
    echo "Commands:"
    printf "  %-25s\n" "create <language>"
    printf "  %-25s\n" "lint <file>"
    printf "  %-25s\n" "optimize <file>"
    printf "  %-25s\n" "template <type>"
    printf "  %-25s\n" "scan <file>"
    printf "  %-25s\n" "list"
    printf "  %%-25s\n" "help"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_version() { echo "$SCRIPT_NAME v$VERSION"; }

main() {
    local cmd="${1:-help}"
    case "$cmd" in
        create) shift; cmd_create "$@" ;;
        lint) shift; cmd_lint "$@" ;;
        optimize) shift; cmd_optimize "$@" ;;
        template) shift; cmd_template "$@" ;;
        scan) shift; cmd_scan "$@" ;;
        list) shift; cmd_list "$@" ;;
        help) cmd_help ;;
        version) cmd_version ;;
        *) die "Unknown: $cmd" ;;
    esac
}

main "$@"
