#!/bin/bash
# FIDO2 - Passwordless Authentication Standard Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FIDO2 REFERENCE                                ║
║          Passwordless Authentication Standard               ║
╚══════════════════════════════════════════════════════════════╝

FIDO2 is an authentication standard that enables passwordless
login using hardware security keys, biometrics, or device PINs.
It's phishing-resistant by design.

FIDO2 COMPONENTS:
  WebAuthn       W3C web API (browser/server)
  CTAP2          Client-to-Authenticator Protocol (key/device)

  Browser ←→ WebAuthn API ←→ CTAP2 ←→ Authenticator
                                        (YubiKey/phone/laptop)

AUTHENTICATOR TYPES:
  Roaming        USB/NFC security keys (YubiKey, Titan)
  Platform       Built-in (Touch ID, Windows Hello, Face ID)

KEY CONCEPTS:
  Registration     Create credential (public key stored on server)
  Authentication   Prove identity (sign challenge with private key)
  Discoverable     Key stores user info (no username needed)
  Non-discoverable Server provides credential ID first

WHY FIDO2:
  ✅ Phishing-proof    Origin-bound (won't work on fake sites)
  ✅ No shared secrets  No passwords to steal/leak
  ✅ Privacy           Different key pair per site
  ✅ Strong crypto      Public-key cryptography
  ❌ Device loss       Need backup key/recovery
  ❌ Not universal     Some sites don't support it yet

FIDO TIMELINE:
  FIDO U2F    2014    Second factor (password + key)
  FIDO2       2018    Passwordless (key replaces password)
  Passkeys    2022    Synced FIDO2 (iCloud/Google sync)
EOF
}

cmd_webauthn() {
cat << 'EOF'
WEBAUTHN API
==============

REGISTRATION (create credential):
  // Server generates challenge
  const options = {
    challenge: crypto.getRandomValues(new Uint8Array(32)),
    rp: { name: "My App", id: "example.com" },
    user: {
      id: Uint8Array.from(userId),
      name: "alice@example.com",
      displayName: "Alice"
    },
    pubKeyCredParams: [
      { type: "public-key", alg: -7 },    // ES256 (ECDSA)
      { type: "public-key", alg: -257 },   // RS256 (RSA)
      { type: "public-key", alg: -8 },     // EdDSA (Ed25519)
    ],
    authenticatorSelection: {
      authenticatorAttachment: "cross-platform",  // or "platform"
      residentKey: "preferred",     // "required" for passkeys
      userVerification: "preferred" // "required" for passwordless
    },
    timeout: 60000,
    attestation: "none"  // or "direct" for enterprise
  };

  const credential = await navigator.credentials.create({
    publicKey: options
  });
  // Send credential.response to server
  // Server stores: credentialId + publicKey

AUTHENTICATION (verify identity):
  const options = {
    challenge: crypto.getRandomValues(new Uint8Array(32)),
    rpId: "example.com",
    allowCredentials: [{   // Omit for discoverable/passkeys
      type: "public-key",
      id: credentialId,    // From registration
    }],
    userVerification: "preferred",
    timeout: 60000,
  };

  const assertion = await navigator.credentials.get({
    publicKey: options
  });
  // Send assertion.response to server
  // Server verifies signature with stored public key

SERVER LIBRARIES:
  Python:  py_webauthn, fido2
  Node.js: @simplewebauthn/server
  Go:      go-webauthn/webauthn
  Rust:    webauthn-rs
  Java:    java-webauthn-server
  PHP:     web-auth/webauthn-lib
  Ruby:    webauthn-ruby

CONDITIONAL UI (autofill passkeys):
  // Check support
  const available = await PublicKeyCredential
    .isConditionalMediationAvailable();

  if (available) {
    const assertion = await navigator.credentials.get({
      publicKey: { challenge, rpId: "example.com" },
      mediation: "conditional"
    });
  }
  // Browser shows passkey in autofill dropdown!
EOF
}

cmd_server() {
cat << 'EOF'
SERVER IMPLEMENTATION
=======================

PYTHON (py_webauthn):
  pip install py-webauthn

  from webauthn import (
      generate_registration_options,
      verify_registration_response,
      generate_authentication_options,
      verify_authentication_response,
  )

  # Registration
  options = generate_registration_options(
      rp_id="example.com",
      rp_name="My App",
      user_id=b"user123",
      user_name="alice@example.com",
  )
  # Send options to browser, receive response
  verification = verify_registration_response(
      credential=response,
      expected_challenge=options.challenge,
      expected_rp_id="example.com",
      expected_origin="https://example.com",
  )
  # Store: verification.credential_id, verification.credential_public_key

  # Authentication
  options = generate_authentication_options(
      rp_id="example.com",
      allow_credentials=[stored_credential_id],
  )
  verification = verify_authentication_response(
      credential=response,
      expected_challenge=options.challenge,
      expected_rp_id="example.com",
      expected_origin="https://example.com",
      credential_public_key=stored_public_key,
      credential_current_sign_count=stored_sign_count,
  )

NODE.JS (@simplewebauthn/server):
  npm install @simplewebauthn/server @simplewebauthn/browser

  import {
    generateRegistrationOptions,
    verifyRegistrationResponse,
    generateAuthenticationOptions,
    verifyAuthenticationResponse,
  } from '@simplewebauthn/server';

  const options = await generateRegistrationOptions({
    rpName: 'My App',
    rpID: 'example.com',
    userName: 'alice@example.com',
  });

  const verification = await verifyRegistrationResponse({
    response: body,
    expectedChallenge: options.challenge,
    expectedOrigin: 'https://example.com',
    expectedRPID: 'example.com',
  });

TESTING:
  # Chrome DevTools → WebAuthn tab
  # Enable "Virtual authenticator environment"
  # Create virtual authenticator (internal/external)
  # Test registration/authentication without hardware

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
FIDO2 - Passwordless Authentication Standard Reference

Commands:
  intro     Overview, authenticator types, timeline
  webauthn  Browser API, registration, authentication
  server    Python/Node.js server implementation, testing

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  webauthn) cmd_webauthn ;;
  server)  cmd_server ;;
  help|*)  show_help ;;
esac
