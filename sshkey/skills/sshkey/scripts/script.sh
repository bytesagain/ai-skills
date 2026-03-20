#!/usr/bin/env bash
# sshkey — SSH key manager
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="3.0.1"

BOLD='\033[1m'; GREEN='\033[0;32m'; RED='\033[0;31m'; RESET='\033[0m'
die() { echo -e "${RED}Error: $1${RESET}" >&2; exit 1; }
info() { echo -e "${GREEN}✓${RESET} $1"; }

cmd_generate() {
    local type="${1:-ed25519}"
    local bits="${2:-}"
    local comment="${3:-$(whoami)@$(hostname)}"
    
    local keyfile="$HOME/.ssh/id_${type}"
    [ -f "$keyfile" ] && die "Key already exists: $keyfile (delete first or use a different type)"
    
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    
    local args=(-t "$type" -C "$comment" -f "$keyfile" -N "")
    if [ -n "$bits" ] && [ "$type" != "ed25519" ]; then
        args+=(-b "$bits")
    fi
    
    ssh-keygen "${args[@]}"
    echo ""
    info "Generated $type key: $keyfile"
    echo "  Public key: ${keyfile}.pub"
    echo ""
    echo "  Public key contents:"
    cat "${keyfile}.pub"
}

cmd_list() {
    local ssh_dir="$HOME/.ssh"
    [ ! -d "$ssh_dir" ] && { echo "  No SSH directory found."; return 0; }
    
    echo -e "${BOLD}SSH Keys${RESET}"
    echo ""
    
    local found=0
    for pub in "$ssh_dir"/*.pub; do
        [ ! -f "$pub" ] && continue
        found=$((found + 1))
        local priv="${pub%.pub}"
        local fp
        fp=$(ssh-keygen -lf "$pub" 2>/dev/null | awk '{print $2}')
        local type
        type=$(ssh-keygen -lf "$pub" 2>/dev/null | awk '{print $NF}' | tr -d '()')
        local bits
        bits=$(ssh-keygen -lf "$pub" 2>/dev/null | awk '{print $1}')
        local comment
        comment=$(awk '{print $3}' "$pub" 2>/dev/null)
        
        echo "  ${found}. $(basename "$priv")"
        echo "     Type: $type ($bits bits)"
        echo "     Fingerprint: $fp"
        echo "     Comment: $comment"
        [ -f "$priv" ] && echo "     Private key: ✓" || echo "     Private key: ✗ (pub only)"
        echo ""
    done
    
    [ "$found" -eq 0 ] && echo "  No keys found in $ssh_dir"
}

cmd_fingerprint() {
    local keyfile="${1:?Usage: sshkey fingerprint <keyfile>}"
    [ ! -f "$keyfile" ] && die "Not found: $keyfile"
    
    echo -e "${BOLD}Key Fingerprint${RESET}"
    echo ""
    echo "  MD5:    $(ssh-keygen -lf "$keyfile" -E md5 2>/dev/null | awk '{print $2}')"
    echo "  SHA256: $(ssh-keygen -lf "$keyfile" -E sha256 2>/dev/null | awk '{print $2}')"
    echo "  Type:   $(ssh-keygen -lf "$keyfile" 2>/dev/null | awk '{print $NF}')"
    echo "  Bits:   $(ssh-keygen -lf "$keyfile" 2>/dev/null | awk '{print $1}')"
}

cmd_copy() {
    local host="${1:?Usage: sshkey copy <user@host> [keyfile]}"
    local keyfile="${2:-$HOME/.ssh/id_ed25519.pub}"
    [ ! -f "$keyfile" ] && keyfile="$HOME/.ssh/id_rsa.pub"
    [ ! -f "$keyfile" ] && die "No public key found. Generate one first: sshkey generate"
    
    if command -v ssh-copy-id >/dev/null 2>&1; then
        ssh-copy-id -i "$keyfile" "$host"
    else
        echo "  Copying public key to $host..."
        cat "$keyfile" | ssh "$host" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
    fi
    info "Key copied to $host"
}

cmd_test() {
    local host="${1:?Usage: sshkey test <user@host>}"
    echo "  Testing SSH connection to $host..."
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "$host" "echo 'SSH connection OK'" 2>/dev/null; then
        info "Connection successful"
    else
        echo -e "  ${RED}Connection failed${RESET}"
        echo "  Possible issues:"
        echo "    - Key not installed on remote host (use: sshkey copy $host)"
        echo "    - Wrong username"
        echo "    - Host not reachable"
        return 1
    fi
}

cmd_info() {
    local keyfile="${1:?Usage: sshkey info <keyfile>}"
    [ ! -f "$keyfile" ] && die "Not found: $keyfile"
    
    echo -e "${BOLD}Key Info${RESET}"
    echo ""
    ssh-keygen -lf "$keyfile" 2>/dev/null | while IFS= read -r line; do
        echo "  $line"
    done
    echo ""
    echo "  File: $keyfile"
    echo "  Size: $(du -h "$keyfile" | cut -f1)"
    echo "  Modified: $(stat -c '%y' "$keyfile" | cut -d. -f1)"
    echo "  Permissions: $(stat -c '%a' "$keyfile")"
    
    local perms
    perms=$(stat -c '%a' "$keyfile")
    if [ "$perms" = "600" ] || [ "$perms" = "644" ]; then
        echo "  Security: ✓ Permissions OK"
    else
        echo -e "  Security: ${RED}✗ Should be 600 (private) or 644 (public)${RESET}"
    fi
}

cmd_authorized_list() {
    local auth="$HOME/.ssh/authorized_keys"
    [ ! -f "$auth" ] && { echo "  No authorized_keys file."; return 0; }
    
    echo -e "${BOLD}Authorized Keys${RESET}"
    echo ""
    local count=0
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        [[ "$line" =~ ^# ]] && continue
        count=$((count + 1))
        local type comment
        type=$(echo "$line" | awk '{print $1}')
        comment=$(echo "$line" | awk '{print $3}')
        local fp
        fp=$(echo "$line" | ssh-keygen -lf /dev/stdin 2>/dev/null | awk '{print $2}' || echo "?")
        echo "  ${count}. $type ${comment:-unknown} ($fp)"
    done < "$auth"
    echo ""
    echo "  Total: $count keys"
}

cmd_authorized_add() {
    local pubkey="${1:?Usage: sshkey authorized-add <pubkey-file-or-string>}"
    local auth="$HOME/.ssh/authorized_keys"
    mkdir -p "$HOME/.ssh"
    
    if [ -f "$pubkey" ]; then
        cat "$pubkey" >> "$auth"
    else
        echo "$pubkey" >> "$auth"
    fi
    chmod 600 "$auth"
    info "Key added to authorized_keys"
}

cmd_audit() {
    echo -e "${BOLD}SSH Key Security Audit${RESET}"
    echo ""
    local issues=0
    
    # Check .ssh permissions
    local ssh_perms
    ssh_perms=$(stat -c '%a' "$HOME/.ssh" 2>/dev/null || echo "missing")
    if [ "$ssh_perms" = "700" ]; then
        echo "  ✓ .ssh directory permissions: $ssh_perms"
    else
        echo -e "  ${RED}✗ .ssh permissions: $ssh_perms (should be 700)${RESET}"
        issues=$((issues + 1))
    fi
    
    # Check private key permissions
    for key in "$HOME/.ssh"/id_*; do
        [ ! -f "$key" ] && continue
        [[ "$key" == *.pub ]] && continue
        local kperms
        kperms=$(stat -c '%a' "$key")
        if [ "$kperms" = "600" ]; then
            echo "  ✓ $(basename "$key"): $kperms"
        else
            echo -e "  ${RED}✗ $(basename "$key"): $kperms (should be 600)${RESET}"
            issues=$((issues + 1))
        fi
        
        # Check key type
        local ktype
        ktype=$(ssh-keygen -lf "$key" 2>/dev/null | awk '{print $NF}' | tr -d '()')
        local kbits
        kbits=$(ssh-keygen -lf "$key" 2>/dev/null | awk '{print $1}')
        if [ "$ktype" = "RSA" ] && [ "$kbits" -lt 2048 ] 2>/dev/null; then
            echo -e "  ${RED}✗ $(basename "$key"): RSA $kbits bits (minimum 2048 recommended)${RESET}"
            issues=$((issues + 1))
        fi
    done
    
    echo ""
    if [ "$issues" -eq 0 ]; then
        info "No issues found"
    else
        echo "  $issues issue(s) found"
    fi
}

show_help() {
    cat << EOF
sshkey v$VERSION — SSH key manager

Usage: sshkey <command> [args]

Key Management:
  generate [type] [bits]         Generate new SSH key (ed25519/rsa/ecdsa)
  list                           List all SSH keys
  fingerprint <keyfile>          Show key fingerprint (MD5 + SHA256)
  info <keyfile>                 Detailed key information

Remote:
  copy <user@host> [keyfile]     Copy public key to remote host
  test <user@host>               Test SSH connection

Authorized Keys:
  authorized-list                List authorized keys
  authorized-add <pubkey>        Add key to authorized_keys

Security:
  audit                          Security audit of SSH keys and permissions

  help                           Show this help
  version                        Show version

Requires: ssh-keygen, ssh
EOF
}

[ $# -eq 0 ] && { show_help; exit 0; }
case "$1" in
    generate|gen) shift; cmd_generate "${1:-ed25519}" "${2:-}" "${3:-}" ;;
    list|ls)      cmd_list ;;
    fingerprint)  shift; cmd_fingerprint "$@" ;;
    copy)         shift; cmd_copy "$@" ;;
    test)         shift; cmd_test "$@" ;;
    info)         shift; cmd_info "$@" ;;
    authorized-list|auth-list)  cmd_authorized_list ;;
    authorized-add|auth-add)    shift; cmd_authorized_add "$@" ;;
    audit)        cmd_audit ;;
    help|-h)      show_help ;;
    version|-v)   echo "sshkey v$VERSION"; echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com" ;;
    *)            echo "Unknown: $1"; show_help; exit 1 ;;
esac
