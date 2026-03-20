#!/usr/bin/env bash
set -euo pipefail
###############################################################################
# SSLGen — SSL Certificate Generator
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
###############################################################################

VERSION="3.0.0"
SCRIPT_NAME="sslgen"

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

usage() {
  cat <<EOF
${BOLD}SSLGen v${VERSION}${NC} — SSL Certificate Generator
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

${BOLD}Usage:${NC}
  $SCRIPT_NAME self-signed <domain>       Generate self-signed cert + key
  $SCRIPT_NAME csr <domain>               Generate CSR + private key
  $SCRIPT_NAME info <certfile>             Show certificate details
  $SCRIPT_NAME verify <certfile>           Verify certificate validity
  $SCRIPT_NAME chain <certfile>            Show certificate chain
  $SCRIPT_NAME expiry <certfile>           Check certificate expiry date

${BOLD}Examples:${NC}
  $SCRIPT_NAME self-signed example.com
  $SCRIPT_NAME csr myapp.local
  $SCRIPT_NAME info /path/to/cert.pem
  $SCRIPT_NAME verify server.crt
  $SCRIPT_NAME expiry /etc/ssl/certs/ca-certificates.crt
EOF
}

require_openssl() {
  if ! command -v openssl &>/dev/null; then
    err "openssl is required but not found. Install it first."
    exit 1
  fi
}

cmd_self_signed() {
  local domain="${1:?Usage: $SCRIPT_NAME self-signed <domain>}"
  local key_file="${domain}.key"
  local cert_file="${domain}.crt"
  local days=365

  info "Generating self-signed certificate for ${BOLD}${domain}${NC}..."

  openssl req -x509 -newkey rsa:2048 -nodes \
    -keyout "$key_file" \
    -out "$cert_file" \
    -days "$days" \
    -subj "/CN=${domain}/O=Self-Signed/C=US" \
    -addext "subjectAltName=DNS:${domain},DNS:*.${domain}" \
    2>/dev/null

  ok "Certificate generated successfully!"
  echo ""
  echo -e "  ${BOLD}Key:${NC}  ${key_file}"
  echo -e "  ${BOLD}Cert:${NC} ${cert_file}"
  echo -e "  ${BOLD}Valid:${NC} ${days} days"
  echo ""
  echo -e "  ${YELLOW}Fingerprint (SHA-256):${NC}"
  openssl x509 -in "$cert_file" -noout -fingerprint -sha256 2>/dev/null | sed 's/^/    /'
}

cmd_csr() {
  local domain="${1:?Usage: $SCRIPT_NAME csr <domain>}"
  local key_file="${domain}.key"
  local csr_file="${domain}.csr"

  info "Generating CSR for ${BOLD}${domain}${NC}..."

  openssl req -new -newkey rsa:2048 -nodes \
    -keyout "$key_file" \
    -out "$csr_file" \
    -subj "/CN=${domain}/O=${domain}/C=US" \
    -addext "subjectAltName=DNS:${domain},DNS:*.${domain}" \
    2>/dev/null

  ok "CSR generated successfully!"
  echo ""
  echo -e "  ${BOLD}Key:${NC} ${key_file}"
  echo -e "  ${BOLD}CSR:${NC} ${csr_file}"
  echo ""
  info "CSR details:"
  openssl req -in "$csr_file" -noout -text 2>/dev/null | grep -E '(Subject:|DNS:)' | sed 's/^/    /'
}

cmd_info() {
  local certfile="${1:?Usage: $SCRIPT_NAME info <certfile>}"

  if [[ ! -f "$certfile" ]]; then
    err "File not found: $certfile"
    exit 1
  fi

  info "Certificate info for ${BOLD}${certfile}${NC}:"
  echo ""

  echo -e "${BOLD}Subject:${NC}"
  openssl x509 -in "$certfile" -noout -subject 2>/dev/null | sed 's/^subject=/  /'

  echo -e "${BOLD}Issuer:${NC}"
  openssl x509 -in "$certfile" -noout -issuer 2>/dev/null | sed 's/^issuer=/  /'

  echo -e "${BOLD}Serial:${NC}"
  openssl x509 -in "$certfile" -noout -serial 2>/dev/null | sed 's/^serial=/  /'

  echo -e "${BOLD}Validity:${NC}"
  openssl x509 -in "$certfile" -noout -dates 2>/dev/null | sed 's/^/  /'

  echo -e "${BOLD}SANs:${NC}"
  openssl x509 -in "$certfile" -noout -ext subjectAltName 2>/dev/null | sed 's/^/  /' || echo "  (none)"

  echo -e "${BOLD}Fingerprint (SHA-256):${NC}"
  openssl x509 -in "$certfile" -noout -fingerprint -sha256 2>/dev/null | sed 's/^/  /'

  echo -e "${BOLD}Signature Algorithm:${NC}"
  openssl x509 -in "$certfile" -noout -text 2>/dev/null | grep "Signature Algorithm" | head -1 | sed 's/^[[:space:]]*/  /'

  echo -e "${BOLD}Public Key:${NC}"
  openssl x509 -in "$certfile" -noout -text 2>/dev/null | grep "Public-Key:" | sed 's/^[[:space:]]*/  /'
}

cmd_verify() {
  local certfile="${1:?Usage: $SCRIPT_NAME verify <certfile>}"

  if [[ ! -f "$certfile" ]]; then
    err "File not found: $certfile"
    exit 1
  fi

  info "Verifying certificate ${BOLD}${certfile}${NC}..."
  echo ""

  # Check if self-signed or needs CA
  local result
  if result=$(openssl verify "$certfile" 2>&1); then
    ok "Certificate verification: PASSED"
    echo "  $result"
  else
    # Try self-signed verification
    if result=$(openssl verify -CAfile "$certfile" "$certfile" 2>&1); then
      ok "Certificate verification: PASSED (self-signed)"
      echo "  $result"
    else
      warn "Certificate verification: FAILED"
      echo "  $result"
    fi
  fi

  echo ""

  # Check expiry
  local end_date
  end_date=$(openssl x509 -in "$certfile" -noout -enddate 2>/dev/null | cut -d= -f2)
  local end_epoch
  end_epoch=$(date -d "$end_date" +%s 2>/dev/null || date -j -f "%b %d %T %Y %Z" "$end_date" +%s 2>/dev/null || echo 0)
  local now_epoch
  now_epoch=$(date +%s)

  if [[ "$end_epoch" -gt 0 ]]; then
    local days_left=$(( (end_epoch - now_epoch) / 86400 ))
    if [[ "$days_left" -lt 0 ]]; then
      err "Certificate EXPIRED ${days_left#-} days ago"
    elif [[ "$days_left" -lt 30 ]]; then
      warn "Certificate expires in ${days_left} days"
    else
      ok "Certificate valid for ${days_left} days"
    fi
  fi
}

cmd_chain() {
  local certfile="${1:?Usage: $SCRIPT_NAME chain <certfile>}"

  if [[ ! -f "$certfile" ]]; then
    err "File not found: $certfile"
    exit 1
  fi

  info "Certificate chain for ${BOLD}${certfile}${NC}:"
  echo ""

  local depth=0
  local tmpfile
  tmpfile=$(mktemp)
  trap 'rm -f "$tmpfile"' EXIT

  # Split PEM bundle into individual certs
  awk 'BEGIN{c=0} /-----BEGIN CERT/{c++} {print > "'"$tmpfile"'." c}' "$certfile"

  local count
  count=$(ls "${tmpfile}".* 2>/dev/null | wc -l)

  if [[ "$count" -eq 0 ]]; then
    # Single cert
    echo -e "  ${BOLD}[0] Leaf Certificate${NC}"
    openssl x509 -in "$certfile" -noout -subject -issuer 2>/dev/null | sed 's/^/      /'
  else
    for f in "${tmpfile}".*; do
      echo -e "  ${BOLD}[${depth}] $([ "$depth" -eq 0 ] && echo "Leaf" || echo "Intermediate/Root") Certificate${NC}"
      openssl x509 -in "$f" -noout -subject -issuer 2>/dev/null | sed 's/^/      /'
      echo ""
      depth=$((depth + 1))
      rm -f "$f"
    done
  fi

  echo -e "  ${CYAN}Chain depth: ${depth:-1}${NC}"
}

cmd_expiry() {
  local certfile="${1:?Usage: $SCRIPT_NAME expiry <certfile>}"

  if [[ ! -f "$certfile" ]]; then
    err "File not found: $certfile"
    exit 1
  fi

  info "Checking expiry for ${BOLD}${certfile}${NC}..."
  echo ""

  local start_date end_date
  start_date=$(openssl x509 -in "$certfile" -noout -startdate 2>/dev/null | cut -d= -f2)
  end_date=$(openssl x509 -in "$certfile" -noout -enddate 2>/dev/null | cut -d= -f2)

  echo -e "  ${BOLD}Not Before:${NC} ${start_date}"
  echo -e "  ${BOLD}Not After:${NC}  ${end_date}"
  echo ""

  local end_epoch now_epoch
  end_epoch=$(date -d "$end_date" +%s 2>/dev/null || echo 0)
  now_epoch=$(date +%s)

  if [[ "$end_epoch" -gt 0 ]]; then
    local days_left=$(( (end_epoch - now_epoch) / 86400 ))
    if [[ "$days_left" -lt 0 ]]; then
      echo -e "  ${RED}${BOLD}EXPIRED${NC} — expired ${days_left#-} days ago"
    elif [[ "$days_left" -eq 0 ]]; then
      echo -e "  ${RED}${BOLD}EXPIRES TODAY${NC}"
    elif [[ "$days_left" -lt 7 ]]; then
      echo -e "  ${RED}⚠ Expires in ${days_left} days — CRITICAL${NC}"
    elif [[ "$days_left" -lt 30 ]]; then
      echo -e "  ${YELLOW}⚠ Expires in ${days_left} days — WARNING${NC}"
    elif [[ "$days_left" -lt 90 ]]; then
      echo -e "  ${YELLOW}Expires in ${days_left} days${NC}"
    else
      echo -e "  ${GREEN}✓ Valid for ${days_left} days${NC}"
    fi
  fi
}

# Main dispatch
require_openssl

case "${1:-}" in
  self-signed) shift; cmd_self_signed "$@" ;;
  csr)         shift; cmd_csr "$@" ;;
  info)        shift; cmd_info "$@" ;;
  verify)      shift; cmd_verify "$@" ;;
  chain)       shift; cmd_chain "$@" ;;
  expiry)      shift; cmd_expiry "$@" ;;
  -h|--help|"") usage ;;
  *)
    err "Unknown command: $1"
    usage
    exit 1
    ;;
esac
