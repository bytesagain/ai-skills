#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT
set -euo pipefail
CMD="${1:-help}"
case "$CMD" in
help) head -20 "$(dirname "$0")/../SKILL.md" | grep -E "^-|^#" ;;
*) echo "Command: $CMD — use 'help' for available commands" ;;
esac
