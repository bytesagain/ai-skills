#!/bin/bash
# NetBird - Open-Source WireGuard VPN Platform Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              NETBIRD REFERENCE                              ║
║          Open-Source WireGuard Network Platform              ║
╚══════════════════════════════════════════════════════════════╝

NetBird creates WireGuard-based overlay networks with zero
configuration. Fully open-source alternative to Tailscale
with built-in access control and identity management.

KEY FEATURES:
  WireGuard       Kernel-level encryption
  SSO             Google, Azure AD, Okta, Keycloak
  ACLs            Policy-based network access
  DNS             Private DNS for your network
  Routes          Expose subnets/networks
  Firewall        Peer-level firewall rules
  Self-hosted     Full control plane available
  Activity log    Who accessed what, when

NETBIRD vs TAILSCALE vs HEADSCALE:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ NetBird  │ Tailscale│Headscale │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ License      │ BSD-3    │ Prop     │ BSD-3    │
  │ Self-hosted  │ Full     │ No       │ Control  │
  │ SSO          │ Native   │ Native   │ OIDC     │
  │ Firewall     │ Built-in │ ACLs     │ ACLs     │
  │ Activity log │ Built-in │ Paid     │ No       │
  │ DNS          │ Built-in │ MagicDNS │ DNS      │
  │ GUI          │ Web UI   │ Web UI   │ 3rd party│
  │ Free tier    │ Unlimited│ 100 dev  │ Self-host│
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  curl -fsSL https://pkgs.netbird.io/install.sh | sh
  netbird up
EOF
}

cmd_usage() {
cat << 'EOF'
SETUP & DAILY USAGE
======================

CLI:
  netbird up                        # Connect to network
  netbird down                      # Disconnect
  netbird status                    # Show status + peers
  netbird status --detail           # Detailed peer info
  netbird routes list               # Show available routes
  netbird ssh <peer>                # SSH to peer via NetBird
  netbird version                   # Version info

LOGIN:
  netbird up                        # Opens browser for SSO
  netbird up --setup-key <key>      # Non-interactive (servers)
  netbird up --management-url https://your.netbird.server  # Self-hosted

  # Setup keys (for headless/server installs)
  # Create in NetBird dashboard → Setup Keys
  # Types: one-off (single use) or reusable

DNS:
  # Peers are accessible by name
  ping my-server.netbird.cloud
  ssh user@dev-box.netbird.cloud

  # Custom DNS nameservers (dashboard)
  # Add internal DNS servers for private domains
  # e.g., *.internal.company.com → 10.0.0.53

ROUTES:
  # Expose a network through a peer
  # Dashboard → Routes → Add Route
  # Network: 192.168.1.0/24
  # Peer: office-gateway
  # Now all NetBird peers can reach 192.168.1.0/24

ACCESS CONTROL:
  # Dashboard → Access Control → Add Policy
  # Source: Group "developers"
  # Destination: Group "dev-servers"
  # Protocol: TCP
  # Ports: 22, 80, 443

  # Groups are assigned via SSO attributes or manually
  # Default: "All" group allows everything

POSTURE CHECKS:
  # Enforce device security before allowing access
  # Dashboard → Posture Checks
  # - OS version minimum
  # - NetBird version minimum
  # - Geo-location restrictions
  # - Peer network range restrictions
EOF
}

cmd_selfhost() {
cat << 'EOF'
SELF-HOSTED DEPLOYMENT
=========================

DOCKER COMPOSE:
  # Clone and configure
  git clone https://github.com/netbirdio/netbird.git
  cd netbird/infrastructure_files

  # Configure
  export NETBIRD_DOMAIN=netbird.example.com
  export NETBIRD_AUTH_OIDC_ISSUER=https://auth.example.com
  export NETBIRD_AUTH_OIDC_CLIENT_ID=netbird
  export NETBIRD_AUTH_AUDIENCE=netbird
  ./configure.sh

  docker compose up -d

COMPONENTS:
  Management     API + Dashboard (Go)
  Signal         Peer connection signaling (Go)
  TURN/STUN      Relay for NAT traversal (coturn)
  Dashboard      Web UI (React)

REQUIREMENTS:
  - Domain with DNS pointing to server
  - OIDC provider (Keycloak, Authentik, Auth0, Google)
  - Ports: 443 (HTTPS), 33073 (Signal), 3478 (TURN)

KEYCLOAK INTEGRATION:
  # 1. Create realm "netbird"
  # 2. Create client "netbird-client"
  #    - Client type: OpenID Connect
  #    - Valid redirect: https://netbird.example.com/*
  # 3. Create client "netbird-backend"
  #    - Service account enabled
  # 4. Set environment variables in NetBird config

API:
  # List peers
  curl -H "Authorization: Token <pat>" \
    https://api.netbird.io/api/peers

  # List groups
  curl -H "Authorization: Token <pat>" \
    https://api.netbird.io/api/groups

  # Create setup key
  curl -X POST -H "Authorization: Token <pat>" \
    -d '{"name":"server-key","type":"reusable","auto_groups":["group-id"]}' \
    https://api.netbird.io/api/setup-keys

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
NetBird - Open-Source WireGuard VPN Platform Reference

Commands:
  intro      Overview, comparison
  usage      CLI, DNS, routes, ACLs, posture checks
  selfhost   Docker Compose, Keycloak, API

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  usage)    cmd_usage ;;
  selfhost) cmd_selfhost ;;
  help|*)   show_help ;;
esac
