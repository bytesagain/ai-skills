#!/bin/bash
# ZeroTier - Software-Defined Networking Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ZEROTIER REFERENCE                             ║
║          Virtual Ethernet Everywhere                        ║
╚══════════════════════════════════════════════════════════════╝

ZeroTier creates virtual Ethernet networks that work like LANs
across the internet. Connect any device anywhere as if they
were on the same local network.

KEY FEATURES:
  Layer 2          Virtual Ethernet (not just L3/IP)
  P2P              Direct connections between devices
  NAT traversal    Works behind firewalls
  Multicast        Broadcast/multicast support
  Bridging         Bridge virtual + physical networks
  Self-hosted      Self-host controller (ZeroTier One)
  Free tier        Up to 25 devices
  Cross-platform   Linux, macOS, Windows, iOS, Android, NAS

LAYER 2 vs LAYER 3:
  ZeroTier (L2)    Virtual Ethernet — DHCP, ARP, multicast work
  Tailscale (L3)   Virtual IP network — routing only
  WireGuard (L3)   Point-to-point tunnels — manual setup

  L2 advantages:
  - Game LAN parties across the internet
  - Network discovery protocols work (mDNS, SSDP)
  - Bridge to physical networks
  - DHCP server can assign addresses

INSTALL:
  curl -s https://install.zerotier.com | sudo bash
  sudo zerotier-cli join <network-id>
EOF
}

cmd_usage() {
cat << 'EOF'
USAGE & NETWORKING
====================

CLI COMMANDS:
  zerotier-cli status              # Node status + address
  zerotier-cli info                # Node ID
  zerotier-cli join <network-id>   # Join network
  zerotier-cli leave <network-id>  # Leave network
  zerotier-cli listnetworks        # Show joined networks
  zerotier-cli listpeers           # Show connected peers
  zerotier-cli get <nwid> ip       # Get assigned IP

CREATE NETWORK:
  # Via my.zerotier.com web UI
  # Or via API:
  curl -X POST "https://api.zerotier.com/api/v1/network" \
    -H "Authorization: token $ZT_TOKEN" \
    -d '{"config":{"name":"mynetwork"}}'

NETWORK SETTINGS:
  # IPv4 auto-assign
  10.147.17.0/24           # Default range
  192.168.191.0/24         # Custom range

  # IPv6
  RFC4193 (/128 per device)
  6PLANE (/80 per device)

  # Access control
  Private (default) → must authorize each device
  Public → anyone with network ID can join

AUTHORIZE DEVICES:
  # Web UI: my.zerotier.com → Network → Members → check box
  # API:
  curl -X POST "https://api.zerotier.com/api/v1/network/$NWID/member/$MEMBER_ID" \
    -H "Authorization: token $ZT_TOKEN" \
    -d '{"config":{"authorized":true}}'

FLOW RULES (firewall):
  # In network settings (Rules section)

  # Allow everything (default)
  accept;

  # Only allow specific ports
  drop
    not ipprotocol tcp
    and not ipprotocol udp;
  accept
    dport 22 or dport 80 or dport 443;
  drop;

  # Block member from accessing others
  drop
    zsrc <member-zt-address>;

  # Tag-based rules
  tag owner id 1
    default 0
    enum 100 engineering
    enum 200 marketing;
  accept
    tor owner 100;  # Engineering can access everything
  drop
    tor owner 200
    and dport 22;   # Marketing can't SSH

DNS:
  # Enable DNS in network settings
  # Set DNS servers: 10.147.17.1 (your DNS server on the network)
  # Set search domain: mynetwork.local
  # Devices can now resolve: myserver.mynetwork.local

BRIDGING:
  # Bridge ZeroTier to physical LAN
  # On a Linux machine connected to both:
  sudo zerotier-cli set <nwid> allowGlobal=true
  sudo ip link set zt<xxxx> master br0
  # Enable in network config: "Allow Ethernet Bridging"
  # Now devices on ZeroTier can reach physical LAN devices
EOF
}

cmd_selfhost() {
cat << 'EOF'
SELF-HOSTED CONTROLLER
=========================

ZTNCUI (web UI controller):
  # github.com/key-networks/ztncui
  docker run -d --name ztncui \
    -p 3443:3443 \
    -e MYADDR=<your-ip> \
    -e ZTNCUI_PASSWD=mypassword \
    keynetworks/ztncui

CONTROLLER API:
  # ZeroTier One includes a controller
  # Enable: add "controller" to local.conf
  sudo zerotier-cli set <nwid> controller

  # API endpoint (localhost:9993)
  curl -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" \
    http://localhost:9993/controller/network

  # Create network
  curl -X POST -d '{}' \
    -H "X-ZT1-Auth: $TOKEN" \
    http://localhost:9993/controller/network/${NODE_ID}______

DOCKER:
  services:
    zerotier:
      image: zerotier/zerotier
      cap_add:
        - NET_ADMIN
        - SYS_ADMIN
      devices:
        - /dev/net/tun
      volumes:
        - zerotier-data:/var/lib/zerotier-one
      environment:
        - ZT_OVERRIDE_LOCAL_CONF=true
      command: <network-id>
      restart: unless-stopped

COMMON USE CASES:
  Home Lab        Access NAS, Plex, Home Assistant from anywhere
  Gaming          LAN games over the internet
  IoT             Connect remote sensors/devices
  Dev environment Access dev servers behind NAT
  Multi-site      Connect office LANs
  Kubernetes      Pod networking across clouds
  Remote access   Replace traditional VPN

ZEROTIER vs TAILSCALE DECISION:
  Choose ZeroTier when:
  - You need Layer 2 (Ethernet bridging, multicast)
  - LAN gaming / network discovery
  - Self-hosted controller
  - Bridge to physical networks

  Choose Tailscale when:
  - Zero-config is priority
  - SSO/identity integration needed
  - MagicDNS and HTTPS certs
  - Funnel (expose to internet)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
ZeroTier - Software-Defined Networking Reference

Commands:
  intro      Overview, L2 vs L3 networking
  usage      CLI, networks, flow rules, DNS, bridging
  selfhost   Controller, Docker, use cases

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  usage)    cmd_usage ;;
  selfhost) cmd_selfhost ;;
  help|*)   show_help ;;
esac
