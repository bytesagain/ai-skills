#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# uuidgen — UUID Generator & Validator
# Generate, validate, and extract UUIDs.
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="uuidgen"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

print_banner() {
  echo "═══════════════════════════════════════════════════════"
  echo "  ${SCRIPT_NAME} v${VERSION} — UUID Generator"
  echo "  Powered by BytesAgain | bytesagain.com"
  echo "═══════════════════════════════════════════════════════"
}

usage() {
  print_banner
  echo ""
  echo "Usage: ${SCRIPT_NAME} <command> [arguments]"
  echo ""
  echo "Commands:"
  echo "  v4                    Generate a single random UUID v4"
  echo "  batch <count>         Generate multiple UUIDs (default: 5, max: 1000)"
  echo "  validate <uuid>       Validate whether a string is a valid UUID"
  echo "  extract <text>        Extract all UUIDs found in text"
  echo "  short                 Generate a short 8-character UUID"
  echo "  version               Show version"
  echo "  help                  Show this help message"
  echo ""
  echo "Examples:"
  echo "  ${SCRIPT_NAME} v4"
  echo "  ${SCRIPT_NAME} batch 10"
  echo "  ${SCRIPT_NAME} validate '550e8400-e29b-41d4-a716-446655440000'"
  echo "  ${SCRIPT_NAME} extract 'ID is 550e8400-e29b-41d4-a716-446655440000 here'"
  echo "  ${SCRIPT_NAME} short"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

# Generate a single UUID v4
generate_uuid() {
  # Try /proc/sys/kernel/random/uuid first (Linux)
  if [[ -r /proc/sys/kernel/random/uuid ]]; then
    cat /proc/sys/kernel/random/uuid
    return
  fi

  # Fall back to python3
  if command -v python3 &>/dev/null; then
    python3 -c 'import uuid; print(uuid.uuid4())'
    return
  fi

  # Fall back to uuidgen binary
  if command -v /usr/bin/uuidgen &>/dev/null; then
    /usr/bin/uuidgen | tr '[:upper:]' '[:lower:]'
    return
  fi

  # Last resort: build from /dev/urandom
  local hex
  hex="$(od -An -tx1 -N16 /dev/urandom | tr -d ' \n')"
  # Set version 4 bits and variant bits
  local p1="${hex:0:8}"
  local p2="${hex:8:4}"
  local p3="4${hex:13:3}"
  # Set variant to 10xx
  local nibble="${hex:16:1}"
  local variant
  case "$nibble" in
    [0-3]) variant="8" ;;
    [4-7]) variant="9" ;;
    [8-b]) variant="a" ;;
    *) variant="b" ;;
  esac
  local p4="${variant}${hex:17:3}"
  local p5="${hex:20:12}"
  echo "${p1}-${p2}-${p3}-${p4}-${p5}"
}

# Generate a short UUID (8 hex chars)
generate_short() {
  if [[ -r /proc/sys/kernel/random/uuid ]]; then
    cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 8
    echo
    return
  fi

  if command -v python3 &>/dev/null; then
    python3 -c 'import uuid; print(uuid.uuid4().hex[:8])'
    return
  fi

  od -An -tx1 -N4 /dev/urandom | tr -d ' \n'
  echo
}

# Validate UUID format (any version)
# Returns 0 for valid, 1 for invalid
is_valid_uuid() {
  local input="$1"
  local lower
  lower="$(echo "$input" | tr '[:upper:]' '[:lower:]')"
  if [[ "$lower" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
    return 0
  fi
  return 1
}

# Detect UUID version
detect_version() {
  local uuid="$1"
  local lower
  lower="$(echo "$uuid" | tr '[:upper:]' '[:lower:]')"
  local version_char="${lower:14:1}"
  case "$version_char" in
    1) echo "v1 (time-based)" ;;
    2) echo "v2 (DCE security)" ;;
    3) echo "v3 (MD5 name-based)" ;;
    4) echo "v4 (random)" ;;
    5) echo "v5 (SHA-1 name-based)" ;;
    7) echo "v7 (Unix epoch time-based)" ;;
    *) echo "v${version_char} (unknown)" ;;
  esac
}

# Detect UUID variant
detect_variant() {
  local uuid="$1"
  local lower
  lower="$(echo "$uuid" | tr '[:upper:]' '[:lower:]')"
  local variant_char="${lower:19:1}"
  case "$variant_char" in
    [0-7]) echo "NCS backward compatibility" ;;
    [89ab]) echo "RFC 4122 / DCE" ;;
    [cd]) echo "Microsoft COM/DCOM" ;;
    [ef]) echo "Reserved for future use" ;;
    *) echo "Unknown" ;;
  esac
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_v4() {
  local uuid
  uuid="$(generate_uuid)"

  echo "┌──────────────────────────────────────────────────┐"
  echo "│  UUID v4 Generated                               │"
  echo "├──────────────────────────────────────────────────┤"
  printf "│  UUID:     %-38s │\n" "${uuid}"
  printf "│  Compact:  %-38s │\n" "$(echo "$uuid" | tr -d '-')"
  printf "│  Upper:    %-38s │\n" "$(echo "$uuid" | tr '[:lower:]' '[:upper:]')"
  printf "│  URN:      %-38s │\n" "urn:uuid:${uuid}"
  echo "└──────────────────────────────────────────────────┘"
}

cmd_batch() {
  local count="${1:-5}"

  # Validate count
  if ! [[ "$count" =~ ^[0-9]+$ ]]; then
    die "Invalid count: '${count}' — must be a positive number"
  fi
  if [[ "$count" -lt 1 ]]; then
    die "Count must be at least 1"
  fi
  if [[ "$count" -gt 1000 ]]; then
    die "Maximum batch size is 1000"
  fi

  echo "═══════════════════════════════════════════════════════"
  echo "  Generating ${count} UUIDs"
  echo "═══════════════════════════════════════════════════════"
  echo ""

  local i=1
  while [[ "$i" -le "$count" ]]; do
    local uuid
    uuid="$(generate_uuid)"
    printf "%4d. %s\n" "$i" "$uuid"
    i=$(( i + 1 ))
  done

  echo ""
  echo "Generated ${count} UUID(s)."
}

cmd_validate() {
  local input="${1:-}"
  [[ -z "$input" ]] && die "Usage: ${SCRIPT_NAME} validate <uuid>"

  local lower
  lower="$(echo "$input" | tr '[:upper:]' '[:lower:]')"

  echo "┌──────────────────────────────────────────────────┐"
  echo "│  UUID Validation                                 │"
  echo "├──────────────────────────────────────────────────┤"
  printf "│  Input:    %-38s │\n" "${input}"

  if is_valid_uuid "$input"; then
    local version variant
    version="$(detect_version "$lower")"
    variant="$(detect_variant "$lower")"
    printf "│  Valid:    %-38s │\n" "✅ YES"
    printf "│  Version:  %-38s │\n" "${version}"
    printf "│  Variant:  %-38s │\n" "${variant}"
    printf "│  Compact:  %-38s │\n" "$(echo "$lower" | tr -d '-')"
  else
    printf "│  Valid:    %-38s │\n" "❌ NO"
    # Show why it's invalid
    local reason=""
    local stripped
    stripped="$(echo "$lower" | tr -d '-')"
    local len=${#input}
    if [[ "$len" -ne 36 ]]; then
      reason="Wrong length (${len} chars, expected 36)"
    elif ! [[ "$lower" =~ ^[0-9a-f-]+$ ]]; then
      reason="Contains non-hex characters"
    else
      reason="Invalid format (expected 8-4-4-4-12 pattern)"
    fi
    printf "│  Reason:   %-38s │\n" "${reason}"
  fi

  echo "└──────────────────────────────────────────────────┘"

  # Return exit code for scripting
  is_valid_uuid "$input"
}

cmd_extract() {
  local text="${1:-}"
  [[ -z "$text" ]] && die "Usage: ${SCRIPT_NAME} extract <text>\n  Pipe text or provide as argument"

  # Read from stdin if text is "-"
  if [[ "$text" == "-" ]]; then
    text="$(cat)"
  fi

  local uuid_pattern='[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'

  local found
  found="$(echo "$text" | grep -oE "$uuid_pattern" || true)"

  if [[ -z "$found" ]]; then
    echo "┌──────────────────────────────────────────────────┐"
    echo "│  UUID Extraction                                 │"
    echo "├──────────────────────────────────────────────────┤"
    echo "│  No UUIDs found in the provided text.            │"
    echo "└──────────────────────────────────────────────────┘"
    exit 0
  fi

  local count
  count="$(echo "$found" | wc -l | tr -d ' ')"

  echo "┌──────────────────────────────────────────────────┐"
  echo "│  UUID Extraction — Found ${count} UUID(s)              │"
  echo "├──────────────────────────────────────────────────┤"

  local i=1
  while IFS= read -r uuid; do
    local version
    version="$(detect_version "$uuid")"
    printf "│  %2d. %-36s %-6s │\n" "$i" "$uuid" "$version"
    i=$(( i + 1 ))
  done <<< "$found"

  echo "└──────────────────────────────────────────────────┘"
}

cmd_short() {
  local short_id
  short_id="$(generate_short)"

  # Also generate a few alternatives
  local alt1 alt2 alt3
  alt1="$(generate_short)"
  alt2="$(generate_short)"
  alt3="$(generate_short)"

  echo "┌──────────────────────────────────────────────────┐"
  echo "│  Short UUID (8 chars)                            │"
  echo "├──────────────────────────────────────────────────┤"
  printf "│  Primary:      %-33s │\n" "${short_id}"
  echo "├──────────────────────────────────────────────────┤"
  echo "│  Alternatives:                                   │"
  printf "│    %-46s │\n" "${alt1}"
  printf "│    %-46s │\n" "${alt2}"
  printf "│    %-46s │\n" "${alt3}"
  echo "└──────────────────────────────────────────────────┘"
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    v4)       cmd_v4 "$@" ;;
    batch)    cmd_batch "$@" ;;
    validate) cmd_validate "$@" ;;
    extract)  cmd_extract "$@" ;;
    short)    cmd_short "$@" ;;
    version)  echo "${SCRIPT_NAME} v${VERSION}" ;;
    help|--help|-h) usage ;;
    *)        die "Unknown command: '${cmd}'. Run '${SCRIPT_NAME} help' for usage." ;;
  esac
}

main "$@"
