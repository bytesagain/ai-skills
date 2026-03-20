#!/usr/bin/env bash
# contract-template — Business contract and agreement templates
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${CONTRACT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/contract-template}"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
contract-template v$VERSION — Contract and agreement templates

Usage: contract-template <command> [args]

Contracts:
  service <provider> <client>    Service agreement
  freelance <name> <client>      Freelance contract
  nda <party1> <party2>          Non-disclosure agreement
  employment <company> <role>    Employment outline

Components:
  scope <desc>                   Scope of work
  payment <amount> <terms>       Payment terms
  termination <days>             Termination clause
  ip <owner>                     IP ownership

Utilities:
  invoice <amount> <client>      Invoice template
  receipt <amount>               Receipt template
  checklist                      Review checklist
  glossary                       Legal terms
  help                           Show this help
EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_service() {
    local provider="${1:?Usage: contract-template service <provider> <client>}"
    local client="${2:?}"
    echo "  ==============================="
    echo "  SERVICE AGREEMENT"
    echo "  ==============================="
    echo "  Date: $(date +%Y-%m-%d)"
    echo "  Between: $provider (Provider)"
    echo "  And: $client (Client)"
    echo ""
    echo "  1. SERVICES: [describe deliverables]"
    echo "  2. TERM: [start] to [end]"
    echo "  3. PAYMENT: \$[amount], [schedule]"
    echo "  4. IP: Transfers to Client on payment"
    echo "  5. CONFIDENTIALITY: Both parties agree"
    echo "  6. TERMINATION: [30] days notice"
    echo "  7. LIABILITY: Capped at fees paid"
    echo ""
    echo "  Provider: ___________  Date: ______"
    echo "  Client:   ___________  Date: ______"
}

cmd_nda() {
    local p1="${1:?}"
    local p2="${2:?}"
    echo "  NON-DISCLOSURE AGREEMENT"
    echo "  Between: $p1 and $p2"
    echo "  Date: $(date +%Y-%m-%d)"
    echo ""
    echo "  1. Confidential Info: All non-public data"
    echo "  2. Obligations: No disclosure to third parties"
    echo "  3. Exclusions: Public info, independent dev"
    echo "  4. Term: 2 years"
    echo "  5. Return materials on request"
}

cmd_freelance() {
    local name="${1:?}"
    local client="${2:?}"
    echo "  FREELANCE CONTRACT"
    echo "  Freelancer: $name | Client: $client"
    echo ""
    echo "  Scope: [detailed work description]"
    echo "  Rate: \$[X]/hour or \$[X] fixed"
    echo "  Payment: Net 30, 50% upfront"
    echo "  Revisions: 2 included"
    echo "  Kill fee: 25% if cancelled"
    echo "  IP: Transfers on full payment"
}

cmd_invoice() {
    local amount="${1:?}"
    local client="${2:?}"
    echo "  INVOICE #INV-$(date +%Y%m%d)-001"
    echo "  Date: $(date +%Y-%m-%d)"
    echo "  Bill To: $client"
    echo "  ─────────────────────"
    echo "  [Service]     \$$amount"
    echo "  ─────────────────────"
    echo "  Total:        \$$amount"
    echo "  Due: 30 days"
}

cmd_checklist() {
    echo "  === Contract Checklist ==="
    echo "  [ ] Parties named correctly?"
    echo "  [ ] Scope defined?"
    echo "  [ ] Payment terms clear?"
    echo "  [ ] Dates specified?"
    echo "  [ ] Termination clause?"
    echo "  [ ] IP ownership?"
    echo "  [ ] Liability limited?"
    echo "  [ ] Dispute resolution?"
    echo "  [ ] Signatures?"
}

cmd_glossary() {
    echo "  === Legal Terms ==="
    echo "  Indemnify     Compensate for loss"
    echo "  Force Majeure Unforeseeable events"
    echo "  Arbitration   Private dispute resolution"
    echo "  Breach        Contract violation"
    echo "  Severability  Invalid parts dont void whole"
    echo "  Escrow        Third-party held funds"
}

case "${1:-help}" in
    service)     shift; cmd_service "$@" ;;
    freelance)   shift; cmd_freelance "$@" ;;
    nda)         shift; cmd_nda "$@" ;;
    employment)  shift; echo "  Employment at $1: Role $2, Start date, Salary, Benefits, PTO" ;;
    scope)       shift; echo "  Scope: $*" ;;
    payment)     shift; echo "  Payment: \$$1, Terms: $2" ;;
    termination) shift; echo "  Termination: $1 days written notice" ;;
    ip)          shift; echo "  IP ownership: All work product belongs to $1" ;;
    invoice)     shift; cmd_invoice "$@" ;;
    receipt)     shift; echo "  Receipt: \$$1 received on $(date +%Y-%m-%d)" ;;
    checklist)   cmd_checklist ;;
    glossary)    cmd_glossary ;;
    help|-h)     show_help ;;
    version|-v)  echo "contract-template v$VERSION" ;;
    *)           echo "Unknown: $1"; show_help; exit 1 ;;
esac
