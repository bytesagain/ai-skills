#!/usr/bin/env bash
# SeedGen — Random seed & data generator
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="seedgen"

# ─────────────────────────────────────────────────────────────
# Usage / Help
# ─────────────────────────────────────────────────────────────
usage() {
  cat <<'EOF'
SeedGen — Random seed & data generator
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

USAGE:
  seedgen <command> [arguments]

COMMANDS:
  string <length>            Generate random alphanumeric string
  hex <bytes>                Generate random hex string (2 hex chars per byte)
  bytes <count>              Generate random bytes (base64 encoded)
  int <min> <max>            Generate random integer in range [min, max]
  float                     Generate random float between 0 and 1
  pick <item1> <item2> ...  Randomly pick one item from the list
  uuid                      Generate a UUID v4
  password <length>         Generate a strong password with mixed chars
  batch <type> <count> [args]  Generate multiple values at once
  help                      Show this help message
  version                   Show version

EXAMPLES:
  seedgen string 32
  seedgen hex 16
  seedgen bytes 64
  seedgen int 1 100
  seedgen float
  seedgen pick red green blue yellow
  seedgen uuid
  seedgen password 20
  seedgen batch string 5 16
EOF
}

# ─────────────────────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────────────────────
die() { echo "ERROR: $*" >&2; exit 1; }

require_arg() {
  if [[ -z "${1:-}" ]]; then
    die "Missing required argument: $2"
  fi
}

# ─────────────────────────────────────────────────────────────
# Commands
# ─────────────────────────────────────────────────────────────

cmd_string() {
  local length="${1:-}"
  require_arg "$length" "length"
  [[ "$length" =~ ^[0-9]+$ ]] || die "Length must be a positive integer"
  [[ "$length" -gt 0 ]] || die "Length must be greater than 0"
  local result
  result=$(tr -dc 'A-Za-z0-9' < /dev/urandom 2>/dev/null | head -c "$length" || true)
  echo "$result"
}

cmd_hex() {
  local bytes="${1:-}"
  require_arg "$bytes" "bytes"
  [[ "$bytes" =~ ^[0-9]+$ ]] || die "Bytes must be a positive integer"
  [[ "$bytes" -gt 0 ]] || die "Bytes must be greater than 0"
  local result
  result=$(head -c "$bytes" /dev/urandom | od -An -tx1 | tr -d ' \n')
  echo "$result"
}

cmd_bytes() {
  local count="${1:-}"
  require_arg "$count" "count"
  [[ "$count" =~ ^[0-9]+$ ]] || die "Count must be a positive integer"
  [[ "$count" -gt 0 ]] || die "Count must be greater than 0"
  local result
  result=$(head -c "$count" /dev/urandom | base64 | tr -d '\n')
  echo "$result"
}

cmd_int() {
  local min="${1:-}"
  local max="${2:-}"
  require_arg "$min" "min"
  require_arg "$max" "max"
  [[ "$min" =~ ^-?[0-9]+$ ]] || die "min must be an integer"
  [[ "$max" =~ ^-?[0-9]+$ ]] || die "max must be an integer"
  [[ "$min" -le "$max" ]] || die "min ($min) must be <= max ($max)"
  local range=$(( max - min + 1 ))
  local rand
  rand=$(( RANDOM * 32768 + RANDOM ))
  echo $(( (rand % range) + min ))
}

cmd_float() {
  awk 'BEGIN { srand(); printf "%.17f\n", rand() }'
}

cmd_pick() {
  local items=("$@")
  [[ ${#items[@]} -gt 0 ]] || die "Provide at least one item to pick from"
  local count=${#items[@]}
  local idx
  idx=$(shuf -i 0-$(( count - 1 )) -n 1)
  echo "${items[$idx]}"
}

cmd_uuid() {
  # Generate UUID v4 from /dev/urandom
  local hex
  hex=$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')
  # Set version (4) and variant (8/9/a/b)
  local p1="${hex:0:8}"
  local p2="${hex:8:4}"
  local p3="4${hex:13:3}"
  local p4
  local variant_nibble="${hex:16:1}"
  # Force variant to 8-b range
  case "$variant_nibble" in
    [0-3]) p4="8${hex:17:3}" ;;
    [4-7]) p4="9${hex:17:3}" ;;
    [8-9a-bA-B]) p4="${variant_nibble}${hex:17:3}" ;;
    *) p4="a${hex:17:3}" ;;
  esac
  local p5="${hex:20:12}"
  echo "${p1:0:8}-${p2}-${p3}-${p4}-${p5}"
}

cmd_password() {
  local length="${1:-16}"
  [[ "$length" =~ ^[0-9]+$ ]] || die "Length must be a positive integer"
  [[ "$length" -ge 4 ]] || die "Password length must be at least 4"
  local charset='A-Za-z0-9!@#%_+='
  local result
  result=$(tr -dc "$charset" < /dev/urandom 2>/dev/null | head -c "$length" || true)
  echo "$result"
}

cmd_batch() {
  local type="${1:-}"
  local count="${2:-}"
  require_arg "$type" "type (string|hex|bytes|int|float|uuid|password)"
  require_arg "$count" "count"
  [[ "$count" =~ ^[0-9]+$ ]] || die "Count must be a positive integer"
  [[ "$count" -gt 0 ]] || die "Count must be > 0"
  shift 2
  local i
  for (( i = 1; i <= count; i++ )); do
    case "$type" in
      string)   cmd_string "${1:-16}" ;;
      hex)      cmd_hex "${1:-16}" ;;
      bytes)    cmd_bytes "${1:-16}" ;;
      int)      cmd_int "${1:-1}" "${2:-100}" ;;
      float)    cmd_float ;;
      uuid)     cmd_uuid ;;
      password) cmd_password "${1:-16}" ;;
      *)        die "Unknown batch type: $type" ;;
    esac
  done
}

# ─────────────────────────────────────────────────────────────
# Main dispatcher
# ─────────────────────────────────────────────────────────────
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    string)   cmd_string "$@" ;;
    hex)      cmd_hex "$@" ;;
    bytes)    cmd_bytes "$@" ;;
    int)      cmd_int "$@" ;;
    float)    cmd_float ;;
    pick)     cmd_pick "$@" ;;
    uuid)     cmd_uuid ;;
    password) cmd_password "$@" ;;
    batch)    cmd_batch "$@" ;;
    version)  echo "$SCRIPT_NAME $VERSION" ;;
    help|--help|-h) usage ;;
    *)        die "Unknown command: $cmd (try 'seedgen help')" ;;
  esac
}

main "$@"
