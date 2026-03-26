#!/bin/bash
# TOTP - Time-Based One-Time Password Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TOTP REFERENCE                                 ║
║          Time-Based One-Time Passwords (RFC 6238)           ║
╚══════════════════════════════════════════════════════════════╝

TOTP generates 6-8 digit codes that change every 30 seconds.
Used by Google Authenticator, Authy, 1Password, and most 2FA
implementations.

HOW TOTP WORKS:
  1. Server generates random secret (base32 encoded)
  2. Secret shared via QR code (otpauth:// URI)
  3. Both sides compute: HMAC-SHA1(secret, time/30)
  4. Extract 6 digits from HMAC output
  5. Code matches → authenticated

  TOTP = HMAC(secret, floor(unix_time / period)) → truncate → 6 digits

PARAMETERS:
  Algorithm    SHA1 (default), SHA256, SHA512
  Digits       6 (default), 7, 8
  Period       30 seconds (default)
  Secret       128-160 bit random (base32 encoded)

TOTP vs HOTP:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ TOTP     │ HOTP     │
  ├──────────────┼──────────┼──────────┤
  │ Counter      │ Time     │ Event    │
  │ Expiry       │ 30 sec   │ Never*   │
  │ Sync issues  │ Clock    │ Counter  │
  │ Security     │ Better   │ Good     │
  │ Standard     │ RFC 6238 │ RFC 4226 │
  │ Usage        │ 2FA apps │ Hardware │
  └──────────────┴──────────┴──────────┘

COMMON APPS:
  Google Authenticator   Basic, no backup/sync
  Authy                  Cloud backup, multi-device
  1Password              Built into password manager
  Bitwarden              Built into password manager
  Microsoft Authenticator Push + TOTP
  Aegis                  Open-source Android
  Raivo                  Open-source iOS
  YubiKey                Hardware OATH-TOTP
EOF
}

cmd_implement() {
cat << 'EOF'
IMPLEMENTATION
================

PYTHON (pyotp):
  pip install pyotp qrcode

  import pyotp, qrcode

  # Generate secret
  secret = pyotp.random_base32()     # e.g., "JBSWY3DPEHPK3PXP"

  # Generate TOTP code
  totp = pyotp.TOTP(secret)
  code = totp.now()                  # e.g., "492039"

  # Verify code
  is_valid = totp.verify("492039")   # True/False
  is_valid = totp.verify("492039", valid_window=1)  # ±30 sec tolerance

  # Provisioning URI (for QR code)
  uri = totp.provisioning_uri(
      name="alice@example.com",
      issuer_name="MyApp"
  )
  # otpauth://totp/MyApp:alice@example.com?secret=JBSWY3DPEHPK3PXP&issuer=MyApp

  # Generate QR code
  qrcode.make(uri).save("totp_qr.png")

NODE.JS (otpauth):
  npm install otpauth qrcode

  import { TOTP } from 'otpauth';

  const totp = new TOTP({
    issuer: 'MyApp',
    label: 'alice@example.com',
    algorithm: 'SHA1',
    digits: 6,
    period: 30,
    secret: 'JBSWY3DPEHPK3PXP',
  });

  const code = totp.generate();
  const isValid = totp.validate({ token: code, window: 1 });
  const uri = totp.toString();  // otpauth:// URI

GO:
  import "github.com/pquerna/otp/totp"

  key, _ := totp.Generate(totp.GenerateOpts{
      Issuer:      "MyApp",
      AccountName: "alice@example.com",
  })
  secret := key.Secret()
  code, _ := totp.GenerateCode(secret, time.Now())
  valid := totp.Validate(code, secret)

OTPAUTH URI FORMAT:
  otpauth://totp/ISSUER:ACCOUNT?secret=BASE32SECRET&issuer=ISSUER&algorithm=SHA1&digits=6&period=30
  
  Parts:
  - Type: totp (or hotp)
  - Label: Issuer:Account
  - secret: Base32 encoded key (required)
  - issuer: Service name (recommended)
  - algorithm: SHA1/SHA256/SHA512
  - digits: 6/7/8
  - period: 30 (seconds)
EOF
}

cmd_security() {
cat << 'EOF'
SECURITY & BEST PRACTICES
============================

SERVER-SIDE:
  1. Generate strong secrets (≥128 bits of entropy)
  2. Store secrets encrypted (not plaintext!)
  3. Use valid_window=1 (accept ±1 period for clock drift)
  4. Rate limit verification attempts (max 5/minute)
  5. Log all 2FA attempts (success + failure)
  6. Provide backup codes (8-10 single-use codes)
  7. Show recovery options during setup
  8. Don't show if code was "close" (timing attack)

BACKUP CODES:
  import secrets
  codes = [secrets.token_hex(4) for _ in range(10)]
  # Store hashed, mark as used after consumption
  # e.g., ["a1b2c3d4", "e5f6g7h8", ...]

RECOVERY FLOW:
  1. User loses phone
  2. Enter backup code → verify identity
  3. Disable old TOTP → set up new device
  4. Generate new backup codes

COMMON MISTAKES:
  ❌ Storing secrets in plaintext
  ❌ No rate limiting on verification
  ❌ Not providing backup codes
  ❌ Using SMS instead of TOTP (SIM swap attacks)
  ❌ Not validating during both login and sensitive actions
  ❌ Allowing unlimited verification window

DATABASE SCHEMA:
  CREATE TABLE user_totp (
      user_id UUID PRIMARY KEY REFERENCES users(id),
      secret_encrypted TEXT NOT NULL,  -- Encrypt with app key
      enabled BOOLEAN DEFAULT false,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      verified_at TIMESTAMPTZ,         -- First successful verify
      last_used_at TIMESTAMPTZ
  );

  CREATE TABLE backup_codes (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID REFERENCES users(id),
      code_hash TEXT NOT NULL,          -- bcrypt hash
      used_at TIMESTAMPTZ              -- NULL = unused
  );

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
TOTP - Time-Based One-Time Password Reference

Commands:
  intro       How TOTP works, parameters, apps
  implement   Python/Node.js/Go code, URI format
  security    Best practices, backup codes, schema

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  implement) cmd_implement ;;
  security)  cmd_security ;;
  help|*)    show_help ;;
esac
