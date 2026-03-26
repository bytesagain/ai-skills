#!/bin/bash
# SAML - Security Assertion Markup Language Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              SAML REFERENCE                                 ║
║          Enterprise Single Sign-On Standard                 ║
╚══════════════════════════════════════════════════════════════╝

SAML 2.0 is the standard for enterprise SSO. It enables users
to log in once (at their identity provider) and access multiple
applications without re-authenticating.

KEY ROLES:
  IdP (Identity Provider)   Authenticates users (Okta, Azure AD)
  SP (Service Provider)     Your application (the one users access)
  User/Browser              Initiates the login flow

SAML FLOW (SP-Initiated):
  1. User visits app (SP)
  2. SP redirects to IdP with SAML AuthnRequest
  3. User authenticates at IdP (password, MFA, etc.)
  4. IdP creates SAML Response (signed XML assertion)
  5. IdP redirects user back to SP with SAML Response
  6. SP validates signature, extracts user info
  7. SP creates session → user is logged in

SAML vs OIDC vs OAuth:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ SAML 2.0 │ OIDC     │ OAuth 2.0│
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Purpose      │ SSO      │ SSO+API  │ API auth │
  │ Format       │ XML      │ JSON/JWT │ JSON     │
  │ Transport    │ Browser  │ Browser  │ API      │
  │ Tokens       │ Assertion│ ID Token │ Access   │
  │ Complexity   │ High     │ Medium   │ Low      │
  │ Enterprise   │ Standard │ Growing  │ N/A      │
  │ Mobile       │ Poor     │ Good     │ Good     │
  │ Year         │ 2005     │ 2014     │ 2012     │
  └──────────────┴──────────┴──────────┴──────────┘

KEY TERMS:
  Assertion       XML document with user info + signature
  ACS URL         Assertion Consumer Service (SP endpoint)
  Entity ID       Unique identifier for SP or IdP
  Metadata        XML describing SP/IdP endpoints + certs
  NameID          User identifier (email, username, etc.)
  Binding         Transport: POST, Redirect, Artifact
  RelayState      URL to redirect to after login
EOF
}

cmd_implement() {
cat << 'EOF'
IMPLEMENTATION
================

SP METADATA (what you give to IdP):
  <?xml version="1.0"?>
  <EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata"
      entityID="https://app.example.com/saml/metadata">
    <SPSSODescriptor
        AuthnRequestsSigned="true"
        protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
      <NameIDFormat>
        urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress
      </NameIDFormat>
      <AssertionConsumerService
          Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
          Location="https://app.example.com/saml/acs"
          index="1"/>
    </SPSSODescriptor>
  </EntityDescriptor>

PYTHON (python3-saml):
  pip install python3-saml

  from onelogin.saml2.auth import OneLogin_Saml2_Auth

  # settings.json
  {
    "sp": {
      "entityId": "https://app.example.com/saml/metadata",
      "assertionConsumerService": {
        "url": "https://app.example.com/saml/acs",
        "binding": "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
      }
    },
    "idp": {
      "entityId": "https://idp.example.com",
      "singleSignOnService": {
        "url": "https://idp.example.com/saml/sso",
        "binding": "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
      },
      "x509cert": "MIICpDCCAYwCCQC..."
    }
  }

  # Login
  auth = OneLogin_Saml2_Auth(request_data, settings)
  return redirect(auth.login())

  # ACS callback
  auth = OneLogin_Saml2_Auth(request_data, settings)
  auth.process_response()
  errors = auth.get_errors()
  if not errors:
      user_email = auth.get_nameid()
      attributes = auth.get_attributes()
      session["user"] = user_email

NODE.JS (passport-saml):
  npm install passport-saml

  const SamlStrategy = require('passport-saml').Strategy;
  passport.use(new SamlStrategy({
    entryPoint: 'https://idp.example.com/saml/sso',
    issuer: 'https://app.example.com',
    cert: fs.readFileSync('./idp-cert.pem', 'utf8'),
    callbackUrl: 'https://app.example.com/saml/acs',
  }, (profile, done) => {
    return done(null, { email: profile.email, name: profile.displayName });
  }));

COMMON IdP SETUP:
  Okta:     Admin → Applications → Add SAML 2.0
  Azure AD: Enterprise Apps → New → SAML
  OneLogin: Apps → Add App → SAML
  Google:   Admin → Apps → Web/Mobile → SAML

  You provide: Entity ID, ACS URL, NameID format
  IdP provides: SSO URL, Certificate, IdP Entity ID

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
SAML - Enterprise SSO Standard Reference

Commands:
  intro       Flow, SAML vs OIDC, key terms
  implement   SP metadata, Python/Node.js, IdP setup

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  implement) cmd_implement ;;
  help|*)    show_help ;;
esac
