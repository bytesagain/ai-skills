#!/usr/bin/env bash
# json-editor v2.0.0 - Advanced JSON Toolkit
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.0"

_log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }

_py_json() {
    python3 -u - "$@" << 'PYEOF'
import sys, json, os

def format_json(data, indent=2):
    return json.dumps(data, indent=indent, ensure_ascii=False)

def compress_json(data):
    return json.dumps(data, separators=(',', ':'), ensure_ascii=False)

def extract_key(data, key_path):
    # Simple dot notation: key1.key2.0.key3
    parts = key_path.split('.')
    curr = data
    try:
        for p in parts:
            if isinstance(curr, list):
                curr = curr[int(p)]
            else:
                curr = curr[p]
        return curr
    except:
        return "Error: Path not found"

cmd = sys.argv[1]
file_path = sys.argv[2]

try:
    with open(file_path, 'r') as f:
        data = json.load(f)
    
    if cmd == "pretty":
        print(format_json(data))
    elif cmd == "minify":
        print(compress_json(data))
    elif cmd == "get":
        print(format_json(extract_key(data, sys.argv[3])))
except Exception as e:
    print(f"JSON Error: {e}")
PYEOF
}

case "${1:-help}" in
    pretty) _py_json pretty "$2" ;;
    minify) _py_json minify "$2" ;;
    get)    _py_json get "$2" "$3" ;;
    *) echo "Usage: script.sh pretty <file> | minify <file> | get <file> <path>" ;;
esac
echo -e "\n📖 More skills: bytesagain.com"
