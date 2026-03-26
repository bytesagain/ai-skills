#!/bin/bash
# Tailscale - WireGuard-Based Mesh VPN Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TAILSCALE REFERENCE                            ║
║          Zero-Config Mesh VPN on WireGuard                  ║
╚══════════════════════════════════════════════════════════════╝

Tailscale is a mesh VPN that creates a secure network between
your devices using WireGuard. No port forwarding, no firewall
rules, just install and connect.

KEY FEATURES:
  Zero-config      Install → login → connected
  WireGuard        Kernel-level encryption, fast
  Mesh network     Devices connect directly (peer-to-peer)
  NAT traversal    Works behind any firewall/NAT
  MagicDNS         hostname.tailnet → device IP
  ACLs             Fine-grained access control
  Exit nodes       Route all traffic through a device
  Subnet routers   Expose entire networks
  Funnel           Expose services to the internet
  SSH              Tailscale SSH (no SSH keys needed)

TAILSCALE vs WIREGUARD vs ZEROTIER:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │Tailscale │ WireGuard│ ZeroTier │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Setup        │ Zero     │ Manual   │ Easy     │
  │ NAT traverse │ Auto     │ Manual   │ Auto     │
  │ Encryption   │ WireGuard│ WireGuard│ Custom   │
  │ ACLs         │ Built-in │ Manual   │ Built-in │
  │ DNS          │ MagicDNS │ Manual   │ DNS      │
  │ SSO          │ Built-in │ No       │ No       │
  │ Free tier    │ 100 dev  │ Free     │ 25 dev   │
  │ Self-hosted  │ Headscale│ Yes      │ Controller│
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Linux
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up

  # macOS
  brew install tailscale

  # Docker
  docker run -d --name tailscale \
    --cap-add=NET_ADMIN \
    tailscale/tailscale
EOF
}

cmd_usage() {
cat << 'EOF'
DAILY USAGE
=============

CONNECT:
  tailscale up                          # Connect to tailnet
  tailscale up --authkey=tskey-auth-... # Non-interactive
  tailscale down                        # Disconnect
  tailscale status                      # Show connected devices
  tailscale netcheck                    # Network connectivity check
  tailscale ping mydevice               # Ping by hostname

MAGICDNS:
  # Every device gets: hostname.tailnet-name.ts.net
  ssh myserver.tailnet.ts.net
  curl http://myserver:8080
  ping myphone

  # Custom DNS
  tailscale set --hostname=prod-api

FILE SHARING:
  tailscale file send myfile.txt myphone:
  tailscale file get .                   # Receive pending files

EXIT NODES (route all traffic):
  # On the exit node device
  tailscale up --advertise-exit-node

  # On the client
  tailscale up --exit-node=exitnode-hostname
  tailscale up --exit-node=                  # Stop using exit node

  # Use case: Route traffic through home when traveling

SUBNET ROUTERS (expose whole networks):
  # On a device in the target network
  tailscale up --advertise-routes=192.168.1.0/24,10.0.0.0/8

  # Now any tailnet device can reach 192.168.1.x
  # Must approve in admin console

TAILSCALE SSH:
  # No SSH keys needed — authenticates via tailnet identity
  tailscale up --ssh
  ssh user@myserver     # Auth via Tailscale, not SSH keys

  # ACL controls who can SSH where

TAILSCALE SERVE (expose local services):
  # Expose port 3000 to your tailnet
  tailscale serve 3000
  tailscale serve https /api http://localhost:8080

  # Now: https://mydevice.tailnet.ts.net → localhost:3000

TAILSCALE FUNNEL (expose to internet):
  # Expose to the public internet!
  tailscale funnel 443
  tailscale funnel https / http://localhost:3000

  # Gets a public URL: https://mydevice.tailnet.ts.net
  # Free HTTPS cert included
EOF
}

cmd_acl() {
cat << 'EOF'
ACLs & SELF-HOSTED
=====================

ACCESS CONTROL (ACL policy):
  {
    "acls": [
      // Allow all users to access all devices
      {"action": "accept", "src": ["*"], "dst": ["*:*"]},

      // Or fine-grained:
      // Developers can access dev servers on any port
      {"action": "accept",
       "src": ["group:developers"],
       "dst": ["tag:dev:*"]},

      // Only ops can SSH to production
      {"action": "accept",
       "src": ["group:ops"],
       "dst": ["tag:prod:22"]},

      // Everyone can reach the DNS server
      {"action": "accept",
       "src": ["*"],
       "dst": ["tag:dns:53"]}
    ],

    "groups": {
      "group:developers": ["alice@example.com", "bob@example.com"],
      "group:ops": ["charlie@example.com"]
    },

    "tagOwners": {
      "tag:dev": ["group:developers"],
      "tag:prod": ["group:ops"],
      "tag:dns": ["group:ops"]
    },

    "ssh": [
      // Allow ops to SSH as root on prod
      {"action": "accept",
       "src": ["group:ops"],
       "dst": ["tag:prod"],
       "users": ["root", "ubuntu"]}
    ]
  }

HEADSCALE (self-hosted control server):
  # Open-source Tailscale control plane
  # github.com/juanfont/headscale

  # Install
  wget https://github.com/juanfont/headscale/releases/latest/download/headscale_linux_amd64
  sudo mv headscale_linux_amd64 /usr/local/bin/headscale
  sudo chmod +x /usr/local/bin/headscale

  # Config (/etc/headscale/config.yaml)
  server_url: https://headscale.example.com:443
  listen_addr: 0.0.0.0:443
  private_key_path: /var/lib/headscale/private.key
  db_type: sqlite3
  db_path: /var/lib/headscale/db.sqlite

  # Create user
  headscale users create myuser

  # Register node
  headscale nodes register --user myuser --key mkey:abc123

  # Client connects to your server
  tailscale up --login-server https://headscale.example.com

TAILSCALE API:
  curl -H "Authorization: Bearer tskey-api-..." \
    https://api.tailscale.com/api/v2/tailnet/-/devices

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Tailscale - Mesh VPN Reference

Commands:
  intro    Overview, comparison with WireGuard/ZeroTier
  usage    Connect, MagicDNS, exit nodes, SSH, Funnel
  acl      Access control, Headscale self-hosted, API

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  usage) cmd_usage ;;
  acl)   cmd_acl ;;
  help|*) show_help ;;
esac
