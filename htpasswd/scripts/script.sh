#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# htpasswd — Apache/Nginx htpasswd File Manager
# Create, manage, and verify htpasswd files for HTTP basic authentication.
#
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="htpasswd"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

print_banner() {
  echo "═══════════════════════════════════════════════════════"
  echo "  ${SCRIPT_NAME} v${VERSION} — htpasswd File Manager"
  echo "  Powered by BytesAgain | bytesagain.com"
  echo "═══════════════════════════════════════════════════════"
}

usage() {
  print_banner
  echo ""
  echo "Usage: ${SCRIPT_NAME} <command> [arguments]"
  echo ""
  echo "Commands:"
  echo "  create <file> <user> <password>   Create a new htpasswd file with a user"
  echo "  add <file> <user> <password>      Add a user to an existing htpasswd file"
  echo "  delete <file> <user>              Remove a user from an htpasswd file"
  echo "  verify <file> <user> <password>   Verify a user's password"
  echo "  list <file>                       List all users in an htpasswd file"
  echo "  version                           Show version"
  echo "  help                              Show this help message"
  echo ""
  echo "Password hash algorithms:"
  echo "  Default: apr1 (Apache MD5) via openssl"
  echo "  Set HTPASSWD_ALGO=sha256 or HTPASSWD_ALGO=sha512 for SHA variants"
  echo ""
  echo "Examples:"
  echo "  ${SCRIPT_NAME} create /etc/nginx/.htpasswd admin secret123"
  echo "  ${SCRIPT_NAME} add /etc/nginx/.htpasswd newuser pass456"
  echo "  ${SCRIPT_NAME} delete /etc/nginx/.htpasswd olduser"
  echo "  ${SCRIPT_NAME} verify /etc/nginx/.htpasswd admin secret123"
  echo "  ${SCRIPT_NAME} list /etc/nginx/.htpasswd"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

check_openssl() {
  command -v openssl &>/dev/null || die "openssl is required but not found. Install it first."
}

# Generate password hash using openssl
# Uses apr1 (Apache MD5) by default, supports sha256/sha512 via env
generate_hash() {
  local password="$1"
  local algo="${HTPASSWD_ALGO:-apr1}"

  case "$algo" in
    apr1)
      openssl passwd -apr1 "$password"
      ;;
    sha256)
      # Use SHA-256 with salt
      local salt
      salt="$(openssl rand -hex 8)"
      openssl passwd -5 -salt "$salt" "$password"
      ;;
    sha512)
      # Use SHA-512 with salt
      local salt
      salt="$(openssl rand -hex 8)"
      openssl passwd -6 -salt "$salt" "$password"
      ;;
    *)
      die "Unknown algorithm: '${algo}'. Supported: apr1, sha256, sha512"
      ;;
  esac
}

# Check if user exists in file
user_exists() {
  local file="$1"
  local user="$2"
  grep -q "^${user}:" "$file" 2>/dev/null
}

# Validate username (no colons, no whitespace)
validate_username() {
  local user="$1"
  if [[ -z "$user" ]]; then
    die "Username cannot be empty"
  fi
  if [[ "$user" =~ : ]]; then
    die "Username cannot contain ':' character"
  fi
  if [[ "$user" =~ [[:space:]] ]]; then
    die "Username cannot contain whitespace"
  fi
  if [[ "${#user}" -gt 255 ]]; then
    die "Username too long (max 255 characters)"
  fi
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_create() {
  local file="${1:-}"
  local user="${2:-}"
  local password="${3:-}"

  [[ -z "$file" || -z "$user" || -z "$password" ]] && \
    die "Usage: ${SCRIPT_NAME} create <file> <user> <password>"

  check_openssl
  validate_username "$user"

  if [[ -f "$file" ]]; then
    die "File '${file}' already exists. Use 'add' to add users, or remove the file first."
  fi

  # Create parent directory if needed
  local dir
  dir="$(dirname "$file")"
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
  fi

  local hash
  hash="$(generate_hash "$password")"
  echo "${user}:${hash}" > "$file"
  chmod 640 "$file"

  echo "┌──────────────────────────────────────────────────┐"
  echo "│  htpasswd File Created                           │"
  echo "├──────────────────────────────────────────────────┤"
  printf "│  File:     %-38s │\n" "${file}"
  printf "│  User:     %-38s │\n" "${user}"
  printf "│  Algo:     %-38s │\n" "${HTPASSWD_ALGO:-apr1}"
  printf "│  Perms:    %-38s │\n" "640 (owner rw, group r)"
  echo "├──────────────────────────────────────────────────┤"
  echo "│  ✅ File created with 1 user                     │"
  echo "└──────────────────────────────────────────────────┘"
}

cmd_add() {
  local file="${1:-}"
  local user="${2:-}"
  local password="${3:-}"

  [[ -z "$file" || -z "$user" || -z "$password" ]] && \
    die "Usage: ${SCRIPT_NAME} add <file> <user> <password>"

  check_openssl
  validate_username "$user"

  if [[ ! -f "$file" ]]; then
    die "File '${file}' does not exist. Use 'create' to create a new file."
  fi

  local hash
  hash="$(generate_hash "$password")"

  if user_exists "$file" "$user"; then
    # Update existing user
    local tmp
    tmp="$(mktemp)"
    sed "s|^${user}:.*|${user}:${hash}|" "$file" > "$tmp"
    mv "$tmp" "$file"

    echo "┌──────────────────────────────────────────────────┐"
    echo "│  User Password Updated                           │"
    echo "├──────────────────────────────────────────────────┤"
    printf "│  File:     %-38s │\n" "${file}"
    printf "│  User:     %-38s │\n" "${user}"
    printf "│  Action:   %-38s │\n" "Password updated"
    echo "├──────────────────────────────────────────────────┤"
    echo "│  ⚠️  User already existed — password replaced     │"
    echo "└──────────────────────────────────────────────────┘"
  else
    # Append new user
    echo "${user}:${hash}" >> "$file"
    local count
    count="$(wc -l < "$file" | tr -d ' ')"

    echo "┌──────────────────────────────────────────────────┐"
    echo "│  User Added                                      │"
    echo "├──────────────────────────────────────────────────┤"
    printf "│  File:     %-38s │\n" "${file}"
    printf "│  User:     %-38s │\n" "${user}"
    printf "│  Algo:     %-38s │\n" "${HTPASSWD_ALGO:-apr1}"
    printf "│  Total:    %-38s │\n" "${count} user(s)"
    echo "├──────────────────────────────────────────────────┤"
    echo "│  ✅ User added successfully                      │"
    echo "└──────────────────────────────────────────────────┘"
  fi
}

cmd_delete() {
  local file="${1:-}"
  local user="${2:-}"

  [[ -z "$file" || -z "$user" ]] && \
    die "Usage: ${SCRIPT_NAME} delete <file> <user>"

  [[ -f "$file" ]] || die "File '${file}' does not exist"

  if ! user_exists "$file" "$user"; then
    die "User '${user}' not found in '${file}'"
  fi

  local tmp
  tmp="$(mktemp)"
  grep -v "^${user}:" "$file" > "$tmp" || true
  mv "$tmp" "$file"

  local remaining
  remaining="$(wc -l < "$file" | tr -d ' ')"

  echo "┌──────────────────────────────────────────────────┐"
  echo "│  User Deleted                                    │"
  echo "├──────────────────────────────────────────────────┤"
  printf "│  File:       %-36s │\n" "${file}"
  printf "│  Deleted:    %-36s │\n" "${user}"
  printf "│  Remaining:  %-36s │\n" "${remaining} user(s)"
  echo "├──────────────────────────────────────────────────┤"
  echo "│  ✅ User removed successfully                    │"
  echo "└──────────────────────────────────────────────────┘"
}

cmd_verify() {
  local file="${1:-}"
  local user="${2:-}"
  local password="${3:-}"

  [[ -z "$file" || -z "$user" || -z "$password" ]] && \
    die "Usage: ${SCRIPT_NAME} verify <file> <user> <password>"

  check_openssl

  [[ -f "$file" ]] || die "File '${file}' does not exist"

  if ! user_exists "$file" "$user"; then
    die "User '${user}' not found in '${file}'"
  fi

  local stored_hash
  stored_hash="$(grep "^${user}:" "$file" | head -1 | cut -d: -f2-)"

  local verified=0

  # Detect hash type and verify
  if [[ "$stored_hash" == '$apr1$'* ]]; then
    # APR1 (Apache MD5)
    local salt
    salt="$(echo "$stored_hash" | cut -d'$' -f3)"
    local computed
    computed="$(openssl passwd -apr1 -salt "$salt" "$password")"
    [[ "$computed" == "$stored_hash" ]] && verified=1
  elif [[ "$stored_hash" == '$5$'* ]]; then
    # SHA-256
    local salt
    salt="$(echo "$stored_hash" | cut -d'$' -f3)"
    local computed
    computed="$(openssl passwd -5 -salt "$salt" "$password")"
    [[ "$computed" == "$stored_hash" ]] && verified=1
  elif [[ "$stored_hash" == '$6$'* ]]; then
    # SHA-512
    local salt
    salt="$(echo "$stored_hash" | cut -d'$' -f3)"
    local computed
    computed="$(openssl passwd -6 -salt "$salt" "$password")"
    [[ "$computed" == "$stored_hash" ]] && verified=1
  elif [[ "$stored_hash" == '{SHA}'* ]]; then
    # SHA1 (legacy)
    local b64pass
    b64pass="$(printf '%s' "$password" | openssl dgst -sha1 -binary | openssl enc -base64)"
    [[ "{SHA}${b64pass}" == "$stored_hash" ]] && verified=1
  else
    # Try crypt-style
    local salt
    salt="${stored_hash:0:2}"
    local computed
    computed="$(openssl passwd -crypt -salt "$salt" "$password" 2>/dev/null || true)"
    [[ "$computed" == "$stored_hash" ]] && verified=1
  fi

  echo "┌──────────────────────────────────────────────────┐"
  echo "│  Password Verification                           │"
  echo "├──────────────────────────────────────────────────┤"
  printf "│  File:     %-38s │\n" "${file}"
  printf "│  User:     %-38s │\n" "${user}"

  if [[ "$verified" -eq 1 ]]; then
    printf "│  Result:   %-38s │\n" "✅ Password CORRECT"
    echo "└──────────────────────────────────────────────────┘"
    return 0
  else
    printf "│  Result:   %-38s │\n" "❌ Password INCORRECT"
    echo "└──────────────────────────────────────────────────┘"
    return 1
  fi
}

cmd_list() {
  local file="${1:-}"
  [[ -z "$file" ]] && die "Usage: ${SCRIPT_NAME} list <file>"
  [[ -f "$file" ]] || die "File '${file}' does not exist"

  local count
  count="$(wc -l < "$file" | tr -d ' ')"

  echo "┌──────────────────────────────────────────────────┐"
  echo "│  htpasswd Users                                  │"
  echo "├──────────────────────────────────────────────────┤"
  printf "│  File:  %-41s │\n" "${file}"
  printf "│  Users: %-41s │\n" "${count}"
  echo "├──────────────────────────────────────────────────┤"

  local i=1
  while IFS=: read -r username hash_val; do
    # Skip empty lines
    [[ -z "$username" ]] && continue

    local hash_type="unknown"
    if [[ "$hash_val" == '$apr1$'* ]]; then
      hash_type="apr1 (MD5)"
    elif [[ "$hash_val" == '$5$'* ]]; then
      hash_type="sha256"
    elif [[ "$hash_val" == '$6$'* ]]; then
      hash_type="sha512"
    elif [[ "$hash_val" == '{SHA}'* ]]; then
      hash_type="sha1"
    elif [[ "${#hash_val}" -eq 13 ]]; then
      hash_type="crypt (DES)"
    fi

    printf "│  %2d. %-20s [%-16s] │\n" "$i" "$username" "$hash_type"
    i=$(( i + 1 ))
  done < "$file"

  echo "└──────────────────────────────────────────────────┘"
}

# ---------------------------------------------------------------------------
# Main dispatch
# ---------------------------------------------------------------------------

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    create)   cmd_create "$@" ;;
    add)      cmd_add "$@" ;;
    delete)   cmd_delete "$@" ;;
    verify)   cmd_verify "$@" ;;
    list)     cmd_list "$@" ;;
    version)  echo "${SCRIPT_NAME} v${VERSION}" ;;
    help|--help|-h) usage ;;
    *)        die "Unknown command: '${cmd}'. Run '${SCRIPT_NAME} help' for usage." ;;
  esac
}

main "$@"
