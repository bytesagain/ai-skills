#!/bin/bash
# Pi-hole - Network-Wide Ad Blocker Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PI-HOLE REFERENCE                              ║
║          Network-Wide Ad & Tracker Blocker                  ║
╚══════════════════════════════════════════════════════════════╝

Pi-hole is a DNS sinkhole that blocks ads, trackers, and malware
at the network level. All devices on your network get ad-free
browsing without installing browser extensions.

HOW IT WORKS:
  Device DNS query → Pi-hole
    ├─ Domain on blocklist? → Return 0.0.0.0 (blocked)
    └─ Domain allowed? → Forward to upstream DNS → Return IP

WHAT IT BLOCKS:
  Ads             Display ads, video pre-rolls, banner ads
  Trackers        Google Analytics, Facebook Pixel, etc.
  Malware         Known malware C2 domains
  Telemetry       Windows/smart TV phone-home domains
  Crypto miners   Browser-based mining scripts

STATS (typical home network):
  15-30% of all DNS queries blocked
  ~150K domains in default blocklist
  ~5ms query response time

INSTALL:
  # One-line install
  curl -sSL https://install.pi-hole.net | bash

  # Docker
  docker run -d --name pihole \
    -p 53:53/tcp -p 53:53/udp -p 80:80 \
    -e TZ='Asia/Shanghai' \
    -e WEBPASSWORD='changeme' \
    -v pihole:/etc/pihole \
    -v dnsmasq:/etc/dnsmasq.d \
    --restart=unless-stopped \
    pihole/pihole:latest

  # Web admin: http://pi.hole/admin or http://<IP>/admin
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION & BLOCKLISTS
=============================

CLI COMMANDS:
  pihole status                    # Status overview
  pihole enable                    # Enable blocking
  pihole disable                   # Disable blocking
  pihole disable 5m                # Disable for 5 minutes
  pihole restartdns                # Restart DNS service
  pihole -up                       # Update Pi-hole
  pihole -g                        # Update gravity (blocklists)
  pihole -t                        # Tail the log
  pihole -c                        # Chronometer (dashboard)
  pihole -q example.com            # Query log for domain
  pihole -q -all example.com       # All results for domain

WHITELIST / BLACKLIST:
  pihole -w example.com            # Whitelist domain
  pihole -w -l                     # List whitelisted
  pihole -w -d example.com         # Remove from whitelist
  pihole -b ads.example.com        # Blacklist domain
  pihole -b -l                     # List blacklisted
  pihole --regex '.*\.doubleclick\.net$'  # Regex blacklist
  pihole --regex -l                # List regex rules

  # Wildcard blocking
  pihole --regex '(^|\.)facebook\.com$'   # Block *.facebook.com

BLOCKLISTS (add via web UI → Group Management → Adlists):
  # Default
  https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts

  # Recommended additions
  https://adaway.org/hosts.txt
  https://v.firebog.net/hosts/Easyprivacy.txt
  https://v.firebog.net/hosts/AdguardDNS.txt
  https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt
  https://zerodot1.gitlab.io/CoinBlockerLists/hosts
  https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt

  # After adding lists:
  pihole -g                        # Update gravity database

DNS SETTINGS:
  # /etc/pihole/setupVars.conf
  PIHOLE_DNS_1=127.0.0.1#5335     # Unbound (recommended)
  PIHOLE_DNS_2=                    # No secondary
  DNSSEC=true                      # Enable DNSSEC
  DNS_FQDN_REQUIRED=true          # Never forward non-FQDN
  DNS_BOGUS_PRIV=true             # Never forward reverse for private

  # Rate limiting (v5.0+)
  # /etc/pihole/pihole-FTL.conf
  RATE_LIMIT=1000/60              # 1000 queries per 60 seconds
  BLOCK_ICLOUD_PR=true            # Block iCloud Private Relay
  MAXDBDAYS=365                   # Keep query log 1 year
EOF
}

cmd_operations() {
cat << 'EOF'
API, MONITORING & ADVANCED
==============================

API (no auth needed for read):
  # Summary
  curl 'http://pi.hole/admin/api.php?summary'
  # {"domains_being_blocked":"150234","dns_queries_today":"12345",
  #  "ads_blocked_today":"3456","ads_percentage_today":"28.0"}

  # Top blocked domains
  curl 'http://pi.hole/admin/api.php?topItems&auth=TOKEN'

  # Query types
  curl 'http://pi.hole/admin/api.php?getQueryTypes&auth=TOKEN'

  # Over time data (10min intervals)
  curl 'http://pi.hole/admin/api.php?overTimeData10mins'

  # Client activity
  curl 'http://pi.hole/admin/api.php?getQuerySources&auth=TOKEN'

  # Enable/disable
  curl 'http://pi.hole/admin/api.php?enable&auth=TOKEN'
  curl 'http://pi.hole/admin/api.php?disable=300&auth=TOKEN'  # 5min

  # Get auth token: cat /etc/pihole/setupVars.conf | grep WEBPASSWORD

GRAVITY DATABASE:
  # Pi-hole stores blocklists in SQLite
  sqlite3 /etc/pihole/gravity.db

  # Count blocked domains
  SELECT COUNT(*) FROM gravity;

  # List all adlists
  SELECT id, address, enabled FROM adlist;

  # Custom DNS entries
  # /etc/pihole/custom.list
  192.168.1.100 nas.local
  192.168.1.50 printer.local

  # Local CNAME records
  # /etc/dnsmasq.d/05-pihole-custom-cname.conf
  cname=nextcloud.home,nas.local

DHCP SERVER (optional):
  # Pi-hole can replace your router's DHCP
  # Web UI → Settings → DHCP
  # This ensures ALL devices use Pi-hole as DNS
  # No more manually setting DNS on each device

ADVANCED BLOCKING:
  # Block entire TLDs
  pihole --regex '.*\.xyz$'
  pihole --regex '.*\.top$'
  pihole --regex '.*\.loan$'

  # Block smart TV telemetry
  pihole -b samsungacr.com
  pihole -b samsungcloudsolution.com
  pihole -b lgtvsdp.com
  pihole --regex '.*\.lgappstv\.com$'

  # Block Windows telemetry
  pihole -b vortex.data.microsoft.com
  pihole -b settings-win.data.microsoft.com
  pihole -b watson.telemetry.microsoft.com

TROUBLESHOOTING:
  pihole -d                        # Generate debug log
  pihole -t                        # Real-time log
  pihole -q domain.com             # Check if domain blocked
  pihole -g                        # Re-download all lists
  dig @127.0.0.1 ads.google.com    # Should return 0.0.0.0
  dig @127.0.0.1 example.com       # Should resolve normally

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Pi-hole - Network-Wide Ad Blocker Reference

Commands:
  intro       How it works, what it blocks
  config      CLI, whitelist/blacklist, blocklists, DNS
  operations  API, gravity DB, advanced blocking

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  config)     cmd_config ;;
  operations) cmd_operations ;;
  help|*)     show_help ;;
esac
