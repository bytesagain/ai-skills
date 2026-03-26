#!/bin/bash
# Passkey - Passwordless Login Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PASSKEY REFERENCE                              ║
║          The Future of Authentication                       ║
╚══════════════════════════════════════════════════════════════╝

Passkeys are FIDO2 credentials that sync across devices via
iCloud Keychain, Google Password Manager, or 1Password.
They replace passwords entirely with biometric or PIN auth.

PASSKEY vs PASSWORD vs 2FA:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Passkey  │ Password │ TOTP 2FA │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Phishing     │ Immune   │ Vuln     │ Vuln     │
  │ Reuse attack │ Immune   │ Vuln     │ N/A      │
  │ Breach risk  │ None     │ High     │ Medium   │
  │ User effort  │ Touch/bio│ Remember │ Copy code│
  │ Sync devices │ Yes      │ Manager  │ App-only │
  │ Recovery     │ Provider │ Email    │ Backup   │
  │ Server stores│ Public key│ Hash    │ Secret   │
  └──────────────┴──────────┴──────────┴──────────┘

PASSKEY PROVIDERS:
  Apple        iCloud Keychain (macOS/iOS/iPadOS)
  Google       Google Password Manager (Chrome/Android)
  Microsoft    Windows Hello
  1Password    Cross-platform sync
  Dashlane     Cross-platform sync
  Bitwarden    Cross-platform sync

HOW IT WORKS:
  1. Register: Site asks browser → browser asks device → 
     biometric/PIN → key pair created → public key sent to server
  2. Login: Site sends challenge → browser asks device →
     biometric/PIN → signs challenge → server verifies signature
  3. No password ever transmitted or stored on server!
EOF
}

cmd_implement() {
cat << 'EOF'
IMPLEMENTATION GUIDE
======================

FRONTEND (register):
  async function registerPasskey() {
    const resp = await fetch('/api/passkey/register/options');
    const options = await resp.json();

    // Browser prompts user for biometric/PIN
    const credential = await navigator.credentials.create({
      publicKey: {
        ...options,
        challenge: base64ToBuffer(options.challenge),
        user: {
          ...options.user,
          id: base64ToBuffer(options.user.id),
        },
      },
    });

    // Send to server
    await fetch('/api/passkey/register/verify', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        id: credential.id,
        rawId: bufferToBase64(credential.rawId),
        response: {
          attestationObject: bufferToBase64(
            credential.response.attestationObject),
          clientDataJSON: bufferToBase64(
            credential.response.clientDataJSON),
        },
        type: credential.type,
      }),
    });
  }

FRONTEND (login):
  async function loginWithPasskey() {
    const resp = await fetch('/api/passkey/login/options');
    const options = await resp.json();

    const assertion = await navigator.credentials.get({
      publicKey: {
        ...options,
        challenge: base64ToBuffer(options.challenge),
      },
    });

    const result = await fetch('/api/passkey/login/verify', {
      method: 'POST',
      body: JSON.stringify({
        id: assertion.id,
        rawId: bufferToBase64(assertion.rawId),
        response: {
          authenticatorData: bufferToBase64(
            assertion.response.authenticatorData),
          clientDataJSON: bufferToBase64(
            assertion.response.clientDataJSON),
          signature: bufferToBase64(
            assertion.response.signature),
        },
      }),
    });
    // result contains session token
  }

CONDITIONAL UI (autofill):
  // Add autocomplete="webauthn" to username input
  <input type="text" autocomplete="username webauthn" />

  // Browser shows passkey option in autofill dropdown
  // User taps → biometric → logged in!

  const assertion = await navigator.credentials.get({
    publicKey: { challenge, rpId: "example.com" },
    mediation: "conditional",  // Key line!
  });

FEATURE DETECTION:
  // Check if passkeys are supported
  if (window.PublicKeyCredential) {
    const available = await PublicKeyCredential
      .isUserVerifyingPlatformAuthenticatorAvailable();
    const conditional = await PublicKeyCredential
      .isConditionalMediationAvailable();
  }
EOF
}

cmd_platforms() {
cat << 'EOF'
PLATFORM SUPPORT & UX
========================

SUPPORT STATUS (2026):
  ✅ Chrome (desktop + Android) — full passkey support
  ✅ Safari (macOS + iOS) — iCloud Keychain sync
  ✅ Edge (Windows) — Windows Hello
  ✅ Firefox — since v122
  ✅ 1Password — cross-platform
  ✅ Bitwarden — cross-platform
  ⚠️ Linux — limited (no native sync, use security keys)

MAJOR SITES WITH PASSKEYS:
  Google, Apple, Microsoft, GitHub, PayPal, Amazon,
  eBay, Best Buy, Shopify, Cloudflare, Uber, WhatsApp,
  TikTok, X/Twitter, LinkedIn, Adobe, Nintendo, Sony

UX BEST PRACTICES:
  1. Offer passkey registration after traditional login
     "Want to skip passwords next time? Set up a passkey"
  2. Keep password login as fallback (not everyone has passkeys)
  3. Show clear icons (fingerprint/face icon)
  4. Explain what happens: "Use your fingerprint to log in"
  5. Handle cross-device: QR code for phone → laptop login
  6. Account recovery: backup passkey, email verification

DATABASE SCHEMA:
  CREATE TABLE passkeys (
      id TEXT PRIMARY KEY,             -- credential ID (base64)
      user_id UUID REFERENCES users(id),
      public_key BYTEA NOT NULL,       -- credential public key
      sign_count BIGINT DEFAULT 0,     -- replay protection
      transports TEXT[],               -- ["usb","nfc","ble","internal"]
      backed_up BOOLEAN DEFAULT false, -- synced passkey?
      device_type TEXT,                -- "singleDevice" or "multiDevice"
      created_at TIMESTAMPTZ DEFAULT NOW(),
      last_used_at TIMESTAMPTZ,
      friendly_name TEXT               -- "iPhone", "YubiKey"
  );

MIGRATION STRATEGY:
  Phase 1: Add passkey option alongside password
  Phase 2: Promote passkey at login ("Try passkey instead?")
  Phase 3: Set passkey as default, password as fallback
  Phase 4: (Optional) Password-optional accounts

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Passkey - Passwordless Login Reference

Commands:
  intro       Overview, comparison, providers
  implement   Frontend code, conditional UI, feature detection
  platforms   Support status, UX best practices, migration

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  implement) cmd_implement ;;
  platforms) cmd_platforms ;;
  help|*)    show_help ;;
esac
