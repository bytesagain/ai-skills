#!/bin/bash
# YubiKey - Hardware Security Key Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              YUBIKEY REFERENCE                              ║
║          Hardware Security Key                              ║
╚══════════════════════════════════════════════════════════════╝

YubiKey is a hardware security key by Yubico. It provides
phishing-resistant 2FA, passwordless login, GPG smartcard,
SSH keys, and more — all in a USB/NFC device.

YUBIKEY PROTOCOLS:
  FIDO2/WebAuthn   Passwordless login (passkeys)
  FIDO U2F         Two-factor authentication
  OTP              One-Time Password (Yubico OTP, HOTP, TOTP)
  PIV              Smart card (X.509 certificates)
  OpenPGP          GPG smartcard (sign, encrypt, auth)
  OATH             TOTP/HOTP codes (like Google Authenticator)
  Static password  Type a fixed password on touch

MODELS:
  ┌──────────────┬──────┬──────┬──────┬──────┬──────┐
  │ Feature      │ 5 NFC│ 5C   │ 5Ci  │ Bio  │ SE   │
  ├──────────────┼──────┼──────┼──────┼──────┼──────┤
  │ USB          │ A    │ C    │ C+Ltg│ C    │ C    │
  │ NFC          │ Yes  │ No   │ No   │ No   │ Yes  │
  │ FIDO2        │ Yes  │ Yes  │ Yes  │ Yes  │ Yes  │
  │ PIV          │ Yes  │ Yes  │ Yes  │ No   │ No   │
  │ OpenPGP      │ Yes  │ Yes  │ Yes  │ No   │ No   │
  │ OATH         │ Yes  │ Yes  │ Yes  │ No   │ No   │
  │ Fingerprint  │ No   │ No   │ No   │ Yes  │ No   │
  │ Price        │ ~$50 │ ~$50 │ ~$75 │ ~$90 │ ~$30 │
  └──────────────┴──────┴──────┴──────┴──────┴──────┘

TOOLS:
  ykman          YubiKey Manager CLI (pip install yubikey-manager)
  ykinfo         YubiKey info (older)
  yubico-piv-tool  PIV operations
  Yubico Auth    Mobile TOTP app
EOF
}

cmd_setup() {
cat << 'EOF'
2FA & PASSKEYS
================

FIDO2 / PASSKEYS (passwordless):
  # Set PIN (required once)
  ykman fido set-pin

  # Register on websites:
  # GitHub → Settings → Security → Passkeys → Add
  # Google → Security → Passkeys → Create
  # Touch YubiKey when prompted
  # No password needed to login!

  # Discoverable credentials (resident keys)
  ykman fido credentials list
  ykman fido credentials delete <credential-id>

  # Reset FIDO (⚠️ deletes all FIDO credentials)
  ykman fido reset

U2F (two-factor, older sites):
  # Same physical action as FIDO2
  # Register: touch key when prompted during 2FA setup
  # Login: enter password, then touch key

  # Supported: Google, GitHub, Dropbox, Facebook, AWS, etc.

TOTP (authenticator codes on YubiKey):
  # Add account (like Google Authenticator but on hardware)
  ykman oath accounts add -t GitHub <secret-key>
  # -t = require touch to reveal code

  # List accounts
  ykman oath accounts list

  # Get code
  ykman oath accounts code GitHub
  # Touch YubiKey → shows 6-digit code

  # Delete
  ykman oath accounts delete GitHub

  # Rename
  ykman oath accounts rename "old-name" "new-name"

YUBICO OTP:
  # Slot 1: short press (default Yubico OTP)
  # Slot 2: long press (configurable)
  ykman otp info
  ykman otp static 2 "MyStaticPassword"     # Static password in slot 2
  ykman otp chalresp 2 <secret>             # Challenge-response
  ykman otp delete 2                        # Clear slot 2
EOF
}

cmd_advanced() {
cat << 'EOF'
GPG, SSH & PIV
================

GPG SMARTCARD (keys live on YubiKey):
  # Move GPG keys to YubiKey (⚠️ one-way — backup first!)
  gpg --edit-key <KEY-ID>
  > keytocard      # Move primary key
  > key 1          # Select subkey
  > keytocard      # Move subkey
  > save

  # Or generate keys directly on YubiKey
  gpg --card-edit
  > admin
  > generate
  # Keys never leave the hardware!

  # Card status
  gpg --card-status

  # Change PIN (default: 123456)
  gpg --card-edit
  > admin
  > passwd
  # PIN: for daily use (3 tries)
  # Admin PIN: for key management (default: 12345678)
  # Reset code: unblock PIN

  # Use: signing/encryption requires physical touch
  git commit -S -m "Signed with YubiKey"
  gpg --encrypt --recipient me@example.com file.txt

SSH WITH YUBIKEY:
  # Method 1: FIDO2 SSH key (OpenSSH 8.2+)
  ssh-keygen -t ed25519-sk -C "yubikey-ssh"
  # Generates sk (security key) SSH key
  # Login requires YubiKey touch
  # Add .pub to ~/.ssh/authorized_keys on servers

  # Resident key (stored on YubiKey, works on any computer)
  ssh-keygen -t ed25519-sk -O resident -C "yubikey-ssh"
  # Retrieve on new computer:
  ssh-add -K    # Loads keys from YubiKey

  # Method 2: GPG agent as SSH agent
  # ~/.gnupg/gpg-agent.conf
  enable-ssh-support
  # ~/.bashrc
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  # Your GPG auth subkey works as SSH key

PIV (smart card certificates):
  # Generate key + self-signed cert
  yubico-piv-tool -s 9a -a generate -o public.pem
  yubico-piv-tool -s 9a -a verify-pin -a selfsign-certificate \
    -S "/CN=Alice/" --valid-days=365 -i public.pem -o cert.pem
  yubico-piv-tool -s 9a -a import-certificate -i cert.pem

  # PIV slots
  9a    Authentication
  9c    Digital Signature
  9d    Key Management
  9e    Card Authentication

  # Change PIV PIN (default: 123456)
  ykman piv access change-pin
  # Change PUK (default: 12345678)
  ykman piv access change-puk
  # Change management key
  ykman piv access change-management-key

YKMAN GENERAL:
  ykman info                    # Device info
  ykman list                    # List connected keys
  ykman config usb --list       # USB interfaces
  ykman config nfc --list       # NFC interfaces
  ykman config usb --enable FIDO2  # Enable FIDO2 over USB
  ykman config usb --disable OTP   # Disable OTP (no accidental types)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
YubiKey - Hardware Security Key Reference

Commands:
  intro      Models, protocols, tools
  setup      FIDO2 passkeys, TOTP, U2F, OTP slots
  advanced   GPG smartcard, SSH, PIV certificates

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  setup)    cmd_setup ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
