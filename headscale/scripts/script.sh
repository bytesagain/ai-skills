#!/bin/bash
# Headscale - Self-Hosted Tailscale Control Server Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              HEADSCALE REFERENCE                            ║
║          Self-Hosted Tailscale Control Server               ║
╚══════════════════════════════════════════════════════════════╝

Headscale is an open-source implementation of the Tailscale
control server. Run your own Tailscale network without
depending on Tailscale's infrastructure.

KEY FEATURES:
  Self-hosted      Full control over your coordination server
  WireGuard        Same WireGuard tunnels as Tailscale
  ACLs             Access control policies
  DNS              MagicDNS equivalent
  Preauth keys     Automated node registration
  OIDC             Single sign-on integration
  DERP             Custom relay servers

HEADSCALE vs TAILSCALE:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Headscale│ Tailscale│
  ├──────────────┼──────────┼──────────┤
  │ Control plane│ Self-host│ Hosted   │
  │ Cost         │ Free     │ Free/Paid│
  │ Privacy      │ Full     │ Trust TS │
  │ SSO          │ OIDC     │ Built-in │
  │ UI           │ Headscale-UI│ Native│
  │ Mobile       │ Limited  │ Full     │
  │ Funnel       │ No       │ Yes      │
  │ Maintenance  │ You      │ Them     │
  └──────────────┴──────────┴──────────┘

INSTALL:
  # Download binary
  wget https://github.com/juanfont/headscale/releases/latest/download/headscale_linux_amd64
  sudo mv headscale_linux_amd64 /usr/local/bin/headscale
  sudo chmod +x /usr/local/bin/headscale

  # Docker
  docker run -v /etc/headscale:/etc/headscale \
    -p 8080:8080 headscale/headscale serve
EOF
}

cmd_setup() {
cat << 'EOF'
SETUP & CONFIGURATION
========================

CONFIG (/etc/headscale/config.yaml):
  server_url: https://headscale.example.com
  listen_addr: 0.0.0.0:8080
  metrics_listen_addr: 0.0.0.0:9090
  private_key_path: /var/lib/headscale/private.key
  noise:
    private_key_path: /var/lib/headscale/noise_private.key

  # Database
  db_type: sqlite3
  db_path: /var/lib/headscale/db.sqlite
  # Or PostgreSQL:
  # db_type: postgres
  # db_host: localhost
  # db_port: 5432
  # db_name: headscale
  # db_user: headscale
  # db_pass: secret

  # IP allocation
  ip_prefixes:
    - 100.64.0.0/10   # IPv4
    - fd7a:115c:a1e0::/48  # IPv6

  # DNS
  dns:
    magic_dns: true
    base_domain: mynet.local
    nameservers:
      global:
        - 1.1.1.1
        - 8.8.8.8
    search_domains: []

  # DERP (relay servers)
  derp:
    server:
      enabled: true
      region_id: 999
      stun_listen_addr: 0.0.0.0:3478
    urls:
      - https://controlplane.tailscale.com/derpmap/default

  # OIDC (SSO)
  oidc:
    issuer: https://auth.example.com
    client_id: headscale
    client_secret: secret
    allowed_domains:
      - example.com

USER MANAGEMENT:
  headscale users create alice
  headscale users list
  headscale users delete alice
  headscale users rename alice bob

NODE MANAGEMENT:
  # Generate preauth key
  headscale preauthkeys create --user alice --expiration 24h
  headscale preauthkeys create --user alice --reusable

  # Register node
  headscale nodes register --user alice --key mkey:abc123

  # List nodes
  headscale nodes list

  # Delete node
  headscale nodes delete --identifier 1

  # Routes
  headscale routes list
  headscale routes enable --route 1
EOF
}

cmd_client() {
cat << 'EOF'
CLIENT SETUP & OPS
====================

CONNECT CLIENT TO HEADSCALE:
  # Linux
  tailscale up --login-server https://headscale.example.com

  # With preauth key (non-interactive)
  tailscale up --login-server https://headscale.example.com \
    --authkey hspreauth-abc123

  # macOS (custom app needed or CLI)
  tailscale up --login-server https://headscale.example.com

  # Android/iOS: limited support, need custom builds

ACL POLICY (/etc/headscale/acl.yaml):
  groups:
    group:dev:
      - alice
      - bob
    group:ops:
      - charlie

  acls:
    - action: accept
      src:
        - group:dev
      dst:
        - tag:dev:*

    - action: accept
      src:
        - group:ops
      dst:
        - "*:*"

  tagOwners:
    tag:dev:
      - group:dev
    tag:prod:
      - group:ops

DOCKER COMPOSE (production):
  services:
    headscale:
      image: headscale/headscale:latest
      restart: always
      ports:
        - "8080:8080"
        - "3478:3478/udp"
      volumes:
        - ./config:/etc/headscale
        - headscale-data:/var/lib/headscale
      command: serve

    headscale-ui:
      image: ghcr.io/gurucomputing/headscale-ui:latest
      restart: always
      ports:
        - "8443:443"

  volumes:
    headscale-data:

REVERSE PROXY (nginx):
  server {
      listen 443 ssl;
      server_name headscale.example.com;
      location / {
          proxy_pass http://localhost:8080;
          proxy_set_header Host $host;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_buffering off;
      }
  }

API:
  # List nodes
  curl -H "Authorization: Bearer $API_KEY" \
    https://headscale.example.com/api/v1/node

  # Create preauth key
  curl -X POST -H "Authorization: Bearer $API_KEY" \
    -d '{"user":"alice","expiration":"2026-04-01T00:00:00Z"}' \
    https://headscale.example.com/api/v1/preauthkey

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Headscale - Self-Hosted Tailscale Control Server Reference

Commands:
  intro    Overview, Tailscale comparison
  setup    Config, users, nodes, preauth keys
  client   Client connection, ACLs, Docker, API

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  setup)  cmd_setup ;;
  client) cmd_client ;;
  help|*) show_help ;;
esac
