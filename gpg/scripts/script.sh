#!/bin/bash
# GPG - GNU Privacy Guard Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              GPG REFERENCE                                  ║
║          Encryption, Signing & Key Management               ║
╚══════════════════════════════════════════════════════════════╝

GPG (GNU Privacy Guard) is the open-source implementation of
the OpenPGP standard. Used for encrypting files, signing
commits, email encryption, and package verification.

COMMON USE CASES:
  Git commit signing     Verify you wrote the code
  Email encryption       PGP/MIME encrypted email
  File encryption        Encrypt sensitive files
  Package signing        Verify software packages (apt, rpm)
  Password managers      pass, gopass use GPG
  SSH authentication     GPG keys as SSH keys
  Document signing       Legal/compliance signatures

KEY TYPES:
  RSA         2048/4096 bit (most compatible)
  Ed25519     Modern elliptic curve (recommended)
  ECDSA       Elliptic curve DSA
  DSA         Legacy, avoid for new keys

INSTALL:
  # Usually pre-installed on Linux
  gpg --version
  # macOS
  brew install gnupg
  # Windows
  # Gpg4win (includes Kleopatra GUI)
EOF
}

cmd_keys() {
cat << 'EOF'
KEY MANAGEMENT
================

GENERATE KEY:
  gpg --full-generate-key
  # Interactive: choose algorithm, key size, expiry, name, email

  # Quick generate (Ed25519, recommended)
  gpg --quick-gen-key "Alice <alice@example.com>" ed25519 sign 2y
  # Creates signing key, expires in 2 years

  # With subkeys (best practice)
  gpg --quick-gen-key "Alice <alice@example.com>" ed25519 cert 0
  # Then add subkeys:
  gpg --quick-add-key <FINGERPRINT> ed25519 sign 1y
  gpg --quick-add-key <FINGERPRINT> cv25519 encr 1y
  gpg --quick-add-key <FINGERPRINT> ed25519 auth 1y

LIST KEYS:
  gpg --list-keys                    # Public keys
  gpg --list-keys --keyid-format long
  gpg --list-secret-keys             # Private keys
  gpg -K                             # Short form
  gpg --list-keys alice@example.com  # Specific

EXPORT:
  gpg --armor --export alice@example.com > public.asc
  gpg --armor --export-secret-keys alice@example.com > private.asc
  # ⚠️ NEVER share private key file!

  # Export for GitHub/GitLab
  gpg --armor --export <KEY-ID>
  # Paste output into GitHub → Settings → GPG keys

IMPORT:
  gpg --import public.asc
  gpg --import private.asc

  # From keyserver
  gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEY-ID>
  gpg --keyserver hkps://keyserver.ubuntu.com --search alice@example.com

  # Upload to keyserver
  gpg --keyserver hkps://keys.openpgp.org --send-keys <KEY-ID>

TRUST:
  gpg --edit-key alice@example.com
  > trust
  > 5          # Ultimate trust
  > save

DELETE:
  gpg --delete-keys <KEY-ID>            # Public key
  gpg --delete-secret-keys <KEY-ID>     # Private key

KEY EXPIRY:
  gpg --edit-key <KEY-ID>
  > expire
  > 1y         # Extend 1 year
  > save
EOF
}

cmd_usage() {
cat << 'EOF'
ENCRYPT, SIGN & GIT
======================

ENCRYPT FILE:
  # For a recipient
  gpg --encrypt --recipient alice@example.com secret.txt
  # Creates secret.txt.gpg

  # For multiple recipients
  gpg --encrypt -r alice@example.com -r bob@example.com file.txt

  # Symmetric (password-based, no keys needed)
  gpg --symmetric secret.txt
  gpg -c secret.txt
  # Prompts for passphrase

  # Encrypt + sign
  gpg --encrypt --sign --recipient alice@example.com file.txt

  # Armor output (base64 text instead of binary)
  gpg --armor --encrypt --recipient alice@example.com file.txt
  # Creates file.txt.asc (text file, safe for email)

DECRYPT:
  gpg --decrypt secret.txt.gpg > secret.txt
  gpg -d secret.txt.gpg > secret.txt
  gpg --output secret.txt --decrypt secret.txt.gpg

SIGN:
  gpg --sign file.txt                    # Binary signature (file.txt.gpg)
  gpg --clearsign file.txt               # Inline text signature (file.txt.asc)
  gpg --detach-sign file.txt             # Separate .sig file
  gpg --armor --detach-sign file.txt     # Separate .asc file

VERIFY:
  gpg --verify file.txt.sig file.txt
  gpg --verify file.txt.asc

GIT COMMIT SIGNING:
  # Configure
  git config --global user.signingkey <KEY-ID>
  git config --global commit.gpgsign true
  git config --global tag.gpgsign true

  # Sign individual commit
  git commit -S -m "Signed commit"

  # Sign tag
  git tag -s v1.0 -m "Signed release"

  # Verify
  git log --show-signature
  git verify-commit HEAD
  git verify-tag v1.0

  # For SSH signing (alternative to GPG):
  git config --global gpg.format ssh
  git config --global user.signingkey ~/.ssh/id_ed25519.pub

GPG-AGENT (caching passphrase):
  # ~/.gnupg/gpg-agent.conf
  default-cache-ttl 3600        # 1 hour
  max-cache-ttl 86400           # 24 hours
  pinentry-program /usr/bin/pinentry-curses

  # Restart agent
  gpgconf --kill gpg-agent
  gpg-agent --daemon

  # SSH via GPG
  # ~/.gnupg/gpg-agent.conf
  enable-ssh-support
  # ~/.bashrc
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

PASS (password manager using GPG):
  pass init <GPG-KEY-ID>
  pass insert email/gmail
  pass show email/gmail
  pass generate web/github 32
  pass git push          # Sync encrypted passwords via git

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
GPG - GNU Privacy Guard Reference

Commands:
  intro    Overview, key types, use cases
  keys     Generate, export, import, trust, expiry
  usage    Encrypt, sign, git signing, gpg-agent, pass

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  keys)  cmd_keys ;;
  usage) cmd_usage ;;
  help|*) show_help ;;
esac
