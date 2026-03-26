#!/bin/bash
# OIDC - OpenID Connect Authentication Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              OIDC REFERENCE                                 ║
║          OpenID Connect Authentication                      ║
╚══════════════════════════════════════════════════════════════╝

OpenID Connect (OIDC) is an identity layer on top of OAuth 2.0.
It adds user authentication to OAuth's authorization framework.
"Sign in with Google/GitHub/Apple" is OIDC.

OIDC = OAuth 2.0 + ID Token (who the user is)

KEY CONCEPTS:
  ID Token       JWT containing user identity claims
  Access Token   Grants access to APIs (OAuth)
  Refresh Token  Long-lived token to get new access tokens
  UserInfo       Endpoint returning user profile
  Claims         User attributes (sub, email, name, etc.)
  Scopes         openid, profile, email, address, phone

OIDC FLOWS:
  Authorization Code    Server-side apps (most secure)
  Code + PKCE           SPAs and mobile (recommended)
  Implicit              Legacy SPAs (deprecated)
  Client Credentials    Machine-to-machine (no user)

OIDC vs OAuth vs SAML:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ OIDC     │ OAuth 2.0│ SAML     │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Purpose      │ AuthN+Z  │ AuthZ    │ AuthN    │
  │ Token format │ JWT      │ Opaque   │ XML      │
  │ Discovery    │ .well-known│ Manual │ Metadata │
  │ User info    │ ID Token │ No       │ Assertion│
  │ Mobile       │ Excellent│ Good     │ Poor     │
  │ Enterprise   │ Growing  │ Standard │ Standard │
  │ Complexity   │ Medium   │ Low      │ High     │
  └──────────────┴──────────┴──────────┴──────────┘

PROVIDERS:
  Google       accounts.google.com
  Apple        appleid.apple.com
  Microsoft    login.microsoftonline.com
  GitHub       github.com (OAuth, partial OIDC)
  Auth0        <tenant>.auth0.com
  Okta         <org>.okta.com
  Keycloak     Self-hosted
  Authelia     Self-hosted (lightweight)
EOF
}

cmd_flows() {
cat << 'EOF'
AUTHORIZATION CODE FLOW (+ PKCE)
===================================

STEP 1 — Redirect to provider:
  GET https://provider.com/authorize?
    response_type=code
    &client_id=YOUR_CLIENT_ID
    &redirect_uri=https://app.com/callback
    &scope=openid profile email
    &state=random_csrf_token
    &code_challenge=SHA256(code_verifier)    # PKCE
    &code_challenge_method=S256

STEP 2 — User authenticates at provider

STEP 3 — Provider redirects back:
  GET https://app.com/callback?
    code=AUTHORIZATION_CODE
    &state=random_csrf_token

STEP 4 — Exchange code for tokens:
  POST https://provider.com/token
  Content-Type: application/x-www-form-urlencoded

  grant_type=authorization_code
  &code=AUTHORIZATION_CODE
  &redirect_uri=https://app.com/callback
  &client_id=YOUR_CLIENT_ID
  &client_secret=YOUR_SECRET           # Server-side only
  &code_verifier=ORIGINAL_VERIFIER     # PKCE

STEP 5 — Receive tokens:
  {
    "access_token": "eyJ...",
    "id_token": "eyJ...",           ← User identity!
    "refresh_token": "eyJ...",
    "token_type": "Bearer",
    "expires_in": 3600
  }

ID TOKEN (JWT) CLAIMS:
  {
    "iss": "https://accounts.google.com",    // Issuer
    "sub": "110169484474386276334",           // Unique user ID
    "aud": "YOUR_CLIENT_ID",                 // Audience
    "exp": 1711234567,                        // Expiry
    "iat": 1711230967,                        // Issued at
    "email": "alice@gmail.com",
    "email_verified": true,
    "name": "Alice Smith",
    "picture": "https://lh3.google.../photo.jpg",
    "nonce": "random_nonce"
  }

USERINFO ENDPOINT:
  GET https://provider.com/userinfo
  Authorization: Bearer ACCESS_TOKEN

  Response:
  {
    "sub": "110169484474386276334",
    "email": "alice@gmail.com",
    "name": "Alice Smith"
  }

DISCOVERY:
  GET https://provider.com/.well-known/openid-configuration
  # Returns all endpoints, supported scopes, algorithms
EOF
}

cmd_implement() {
cat << 'EOF'
IMPLEMENTATION
================

PYTHON (authlib):
  pip install authlib httpx

  from authlib.integrations.starlette_client import OAuth
  oauth = OAuth()
  oauth.register(
      name="google",
      client_id="YOUR_CLIENT_ID",
      client_secret="YOUR_SECRET",
      server_metadata_url="https://accounts.google.com/.well-known/openid-configuration",
      client_kwargs={"scope": "openid email profile"},
  )

  # Login route
  @app.get("/login")
  async def login(request):
      redirect_uri = request.url_for("callback")
      return await oauth.google.authorize_redirect(request, redirect_uri)

  # Callback route
  @app.get("/callback")
  async def callback(request):
      token = await oauth.google.authorize_access_token(request)
      user = token.get("userinfo")
      # user = {"email": "alice@gmail.com", "name": "Alice", ...}

NODE.JS (openid-client):
  npm install openid-client

  import { Issuer } from 'openid-client';

  const issuer = await Issuer.discover('https://accounts.google.com');
  const client = new issuer.Client({
    client_id: 'YOUR_CLIENT_ID',
    client_secret: 'YOUR_SECRET',
    redirect_uris: ['https://app.com/callback'],
  });

  // Login URL
  const url = client.authorizationUrl({
    scope: 'openid email profile',
    code_challenge: codeChallenge,
    code_challenge_method: 'S256',
  });

  // Callback
  const tokenSet = await client.callback(
    'https://app.com/callback',
    params,
    { code_verifier: codeVerifier }
  );
  const claims = tokenSet.claims();
  // { sub, email, name, ... }

JWT VALIDATION (verify ID token):
  1. Decode header → get kid (key ID)
  2. Fetch JWKS from provider (/.well-known/jwks.json)
  3. Find matching public key by kid
  4. Verify signature (RS256/ES256)
  5. Verify claims: iss, aud, exp, iat, nonce

  # Python
  from jose import jwt
  claims = jwt.decode(id_token, jwks, algorithms=["RS256"],
                      audience="YOUR_CLIENT_ID",
                      issuer="https://accounts.google.com")

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
OIDC - OpenID Connect Authentication Reference

Commands:
  intro       Overview, flows, comparison
  flows       Authorization Code + PKCE step by step
  implement   Python/Node.js, JWT validation

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  flows)     cmd_flows ;;
  implement) cmd_implement ;;
  help|*)    show_help ;;
esac
