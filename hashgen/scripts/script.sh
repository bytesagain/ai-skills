#!/usr/bin/env bash
# HashGen — Quick hash generator
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="3.0.0"
SCRIPT_NAME="hashgen"

# ─────────────────────────────────────────────────────────────
# Usage / Help
# ─────────────────────────────────────────────────────────────
usage() {
  cat <<'EOF'
HashGen — Quick hash generator
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

USAGE:
  hashgen <command> [arguments]

COMMANDS:
  md5 <text>              MD5 hash of text
  sha1 <text>             SHA1 hash of text
  sha256 <text>           SHA256 hash of text
  sha512 <text>           SHA512 hash of text
  all <text>              Show all hash algorithms for text
  file <path> [algo]      Hash a file (algo: md5|sha1|sha256|sha512, default: sha256)
  compare <hash1> <hash2> Compare two hashes (constant-time-ish)
  verify <text> <hash>    Verify text matches a given hash (auto-detects algo)
  help                    Show this help message
  version                 Show version

EXAMPLES:
  hashgen md5 "hello world"
  hashgen sha256 "my secret"
  hashgen all "test string"
  hashgen file /etc/hostname
  hashgen file /etc/hostname md5
  hashgen compare abc123 abc123
  hashgen verify "hello" 5d41402abc4b2a76b9719d911017c592
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

hash_text() {
  local algo="$1"
  local text="$2"
  case "$algo" in
    md5)    echo -n "$text" | md5sum    | awk '{print $1}' ;;
    sha1)   echo -n "$text" | sha1sum   | awk '{print $1}' ;;
    sha256) echo -n "$text" | sha256sum | awk '{print $1}' ;;
    sha512) echo -n "$text" | sha512sum | awk '{print $1}' ;;
    *)      die "Unknown algorithm: $algo" ;;
  esac
}

hash_file() {
  local filepath="$1"
  local algo="$2"
  [[ -f "$filepath" ]] || die "File not found: $filepath"
  [[ -r "$filepath" ]] || die "File not readable: $filepath"
  case "$algo" in
    md5)    md5sum    "$filepath" | awk '{print $1}' ;;
    sha1)   sha1sum   "$filepath" | awk '{print $1}' ;;
    sha256) sha256sum "$filepath" | awk '{print $1}' ;;
    sha512) sha512sum "$filepath" | awk '{print $1}' ;;
    *)      die "Unknown algorithm: $algo" ;;
  esac
}

detect_algo() {
  local hash="$1"
  local len=${#hash}
  case "$len" in
    32)  echo "md5" ;;
    40)  echo "sha1" ;;
    64)  echo "sha256" ;;
    128) echo "sha512" ;;
    *)   echo "unknown" ;;
  esac
}

# ─────────────────────────────────────────────────────────────
# Commands
# ─────────────────────────────────────────────────────────────

cmd_md5() {
  local text="${1:-}"
  require_arg "$text" "text"
  local result
  result=$(hash_text md5 "$text")
  echo "MD5: $result"
}

cmd_sha1() {
  local text="${1:-}"
  require_arg "$text" "text"
  local result
  result=$(hash_text sha1 "$text")
  echo "SHA1: $result"
}

cmd_sha256() {
  local text="${1:-}"
  require_arg "$text" "text"
  local result
  result=$(hash_text sha256 "$text")
  echo "SHA256: $result"
}

cmd_sha512() {
  local text="${1:-}"
  require_arg "$text" "text"
  local result
  result=$(hash_text sha512 "$text")
  echo "SHA512: $result"
}

cmd_all() {
  local text="${1:-}"
  require_arg "$text" "text"
  echo "Input:  \"$text\""
  echo "Length: ${#text} characters"
  echo "─────────────────────────────────────"
  echo "MD5:    $(hash_text md5 "$text")"
  echo "SHA1:   $(hash_text sha1 "$text")"
  echo "SHA256: $(hash_text sha256 "$text")"
  echo "SHA512: $(hash_text sha512 "$text")"
}

cmd_file() {
  local filepath="${1:-}"
  local algo="${2:-sha256}"
  require_arg "$filepath" "file path"
  local result
  result=$(hash_file "$filepath" "$algo")
  local size
  size=$(stat -c%s "$filepath" 2>/dev/null || stat -f%z "$filepath" 2>/dev/null || echo "?")
  echo "File:   $filepath"
  echo "Size:   $size bytes"
  echo "Algo:   ${algo^^}"
  echo "Hash:   $result"
}

cmd_compare() {
  local hash1="${1:-}"
  local hash2="${2:-}"
  require_arg "$hash1" "hash1"
  require_arg "$hash2" "hash2"
  # Normalize to lowercase
  hash1=$(echo "$hash1" | tr '[:upper:]' '[:lower:]')
  hash2=$(echo "$hash2" | tr '[:upper:]' '[:lower:]')
  if [[ "$hash1" == "$hash2" ]]; then
    echo "✅ MATCH — hashes are identical"
    return 0
  else
    echo "❌ MISMATCH — hashes differ"
    echo "  Hash 1: $hash1"
    echo "  Hash 2: $hash2"
    return 1
  fi
}

cmd_verify() {
  local text="${1:-}"
  local expected="${2:-}"
  require_arg "$text" "text"
  require_arg "$expected" "expected hash"
  local algo
  algo=$(detect_algo "$expected")
  if [[ "$algo" == "unknown" ]]; then
    die "Cannot auto-detect algorithm for hash of length ${#expected}. Supported: 32(md5), 40(sha1), 64(sha256), 128(sha512)"
  fi
  local computed
  computed=$(hash_text "$algo" "$text")
  expected=$(echo "$expected" | tr '[:upper:]' '[:lower:]')
  echo "Algorithm: ${algo^^}"
  echo "Computed:  $computed"
  echo "Expected:  $expected"
  if [[ "$computed" == "$expected" ]]; then
    echo "✅ VERIFIED — text matches hash"
    return 0
  else
    echo "❌ FAILED — text does not match hash"
    return 1
  fi
}

# ─────────────────────────────────────────────────────────────
# Main dispatcher
# ─────────────────────────────────────────────────────────────
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    md5)     cmd_md5 "$@" ;;
    sha1)    cmd_sha1 "$@" ;;
    sha256)  cmd_sha256 "$@" ;;
    sha512)  cmd_sha512 "$@" ;;
    all)     cmd_all "$@" ;;
    file)    cmd_file "$@" ;;
    compare) cmd_compare "$@" ;;
    verify)  cmd_verify "$@" ;;
    version) echo "$SCRIPT_NAME $VERSION" ;;
    help|--help|-h) usage ;;
    *)       die "Unknown command: $cmd (try 'hashgen help')" ;;
  esac
}

main "$@"
