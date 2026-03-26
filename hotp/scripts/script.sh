#!/bin/bash
# HOTP - HMAC-Based One-Time Password Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              HOTP REFERENCE                                 ║
║          HMAC-Based One-Time Passwords (RFC 4226)           ║
╚══════════════════════════════════════════════════════════════╝

HOTP generates one-time passwords based on a counter value.
Unlike TOTP (time-based), HOTP codes don't expire — they're
valid until the next code is generated.

HOW HOTP WORKS:
  1. Server and client share: secret + counter
  2. Both compute: HMAC-SHA1(secret, counter)
  3. Truncate HMAC to 6 digits
  4. On successful verify: counter increments on both sides

  HOTP = HMAC(secret, counter) → truncate → 6 digits

  Unlike TOTP:
  - HOTP uses a counter (events), not time
  - Codes don't expire (valid until used)
  - Counter must stay in sync

WHERE HOTP IS USED:
  Hardware tokens     RSA SecurID, classic keyfobs
  Banking tokens      Digipass, SafeNet
  Offline devices     No clock needed
  Legacy systems      Pre-TOTP implementations

HOTP vs TOTP:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ HOTP     │ TOTP     │
  ├──────────────┼──────────┼──────────┤
  │ Based on     │ Counter  │ Time     │
  │ Expiry       │ Never    │ 30 sec   │
  │ Replay risk  │ Higher   │ Lower    │
  │ Sync issue   │ Counter  │ Clock    │
  │ Offline      │ Yes      │ Needs clock│
  │ Modern use   │ Legacy   │ Standard │
  │ RFC          │ 4226     │ 6238     │
  └──────────────┴──────────┴──────────┘
EOF
}

cmd_implement() {
cat << 'EOF'
IMPLEMENTATION
================

ALGORITHM (step by step):
  1. Counter to 8-byte big-endian:
     counter = 7 → 0x0000000000000007

  2. HMAC-SHA1:
     hmac = HMAC-SHA1(secret, counter_bytes)
     # 20-byte output

  3. Dynamic truncation:
     offset = hmac[19] & 0x0F
     code = (hmac[offset] & 0x7F) << 24
            | hmac[offset+1] << 16
            | hmac[offset+2] << 8
            | hmac[offset+3]
     code = code % 10^digits

PYTHON (pyotp):
  import pyotp

  secret = pyotp.random_base32()
  hotp = pyotp.HOTP(secret)

  # Generate codes at specific counters
  code_0 = hotp.at(0)    # First code
  code_1 = hotp.at(1)    # Second code
  code_2 = hotp.at(2)    # Third code

  # Verify (checks counter range)
  is_valid = hotp.verify(code_1, 1)  # True at counter=1

  # Provisioning URI
  uri = hotp.provisioning_uri(
      name="alice@example.com",
      issuer_name="MyApp",
      initial_count=0
  )
  # otpauth://hotp/MyApp:alice@example.com?secret=XXX&issuer=MyApp&counter=0

PYTHON (from scratch):
  import hmac, hashlib, struct

  def hotp(secret_bytes, counter, digits=6):
      # Step 1: HMAC-SHA1
      msg = struct.pack(">Q", counter)  # 8-byte big-endian
      h = hmac.new(secret_bytes, msg, hashlib.sha1).digest()

      # Step 2: Dynamic truncation
      offset = h[19] & 0x0F
      code = ((h[offset] & 0x7F) << 24
              | h[offset+1] << 16
              | h[offset+2] << 8
              | h[offset+3])

      # Step 3: Modulo for digit count
      return str(code % (10 ** digits)).zfill(digits)

  # Usage
  import base64
  secret = base64.b32decode("JBSWY3DPEHPK3PXP")
  print(hotp(secret, 0))   # Code at counter=0
  print(hotp(secret, 1))   # Code at counter=1

NODE.JS:
  import { HOTP } from 'otpauth';

  const hotp = new HOTP({
    issuer: 'MyApp',
    label: 'alice@example.com',
    secret: 'JBSWY3DPEHPK3PXP',
    digits: 6,
    counter: 0,
  });

  const code = hotp.generate({ counter: 0 });
  const delta = hotp.validate({ token: code, counter: 0, window: 10 });
  // delta = counter difference (null if invalid)
EOF
}

cmd_security() {
cat << 'EOF'
COUNTER SYNC & SECURITY
==========================

COUNTER SYNCHRONIZATION:
  Problem: client presses button without server seeing it
  → Counter drifts (client=5, server=3)

  Solution: Look-ahead window
  - Server tries counter, counter+1, counter+2, ... counter+N
  - If match found at counter+K, update server counter to K+1
  - Typical window: 10 attempts

  def verify_hotp(secret, code, server_counter, window=10):
      for i in range(window):
          if hotp(secret, server_counter + i) == code:
              return server_counter + i + 1  # New counter
      return None  # Invalid

RESYNC PROTOCOL:
  # If counter drifts too far:
  # 1. Ask user to generate 2 consecutive codes
  # 2. Search large window (100+) for the pair
  # 3. If both match sequentially → resync counter

SECURITY CONSIDERATIONS:
  ❌ Codes never expire → stolen code works forever (until counter moves)
  ❌ Counter desync → usability issue
  ❌ No replay protection without server tracking
  ✅ Works offline (no clock needed)
  ✅ Simpler than TOTP

  Mitigations:
  - Limit look-ahead window (max 10)
  - Rate limit verification (5 attempts/minute)
  - Mark codes as used (prevent replay)
  - Use TOTP instead for new implementations

DATABASE SCHEMA:
  CREATE TABLE user_hotp (
      user_id UUID PRIMARY KEY REFERENCES users(id),
      secret_encrypted TEXT NOT NULL,
      counter BIGINT DEFAULT 0,        -- Current server counter
      enabled BOOLEAN DEFAULT false,
      last_verified_at TIMESTAMPTZ
  );

WHEN TO USE HOTP:
  ✅ Hardware tokens without clocks
  ✅ Offline environments
  ✅ Legacy system compatibility
  ❌ New implementations (use TOTP instead)
  ❌ Mobile apps (TOTP is better)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
HOTP - HMAC-Based One-Time Password Reference

Commands:
  intro       How HOTP works, HOTP vs TOTP
  implement   Python/Node.js, algorithm from scratch
  security    Counter sync, resync, security tips

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  implement) cmd_implement ;;
  security)  cmd_security ;;
  help|*)    show_help ;;
esac
