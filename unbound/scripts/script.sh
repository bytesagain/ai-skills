#!/bin/bash
# Unbound - Recursive DNS Resolver Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              UNBOUND REFERENCE                              ║
║          Validating, Recursive DNS Resolver                 ║
╚══════════════════════════════════════════════════════════════╝

Unbound is a validating, recursive, caching DNS resolver.
It resolves DNS queries from root servers (no forwarding to
third parties) and validates DNSSEC signatures.

DNS RESOLVER TYPES:
  Recursive   Unbound queries root → TLD → auth servers
  Forwarder   Sends queries to upstream (8.8.8.8, 1.1.1.1)
  Authoritative  Answers for zones it hosts (BIND, PowerDNS)

UNBOUND vs BIND vs PI-HOLE:
  ┌──────────────────┬──────────────┬──────────────┬──────────┐
  │ Feature          │ Unbound      │ BIND         │ Pi-hole  │
  ├──────────────────┼──────────────┼──────────────┼──────────┤
  │ Primary role     │ Recursive    │ Authoritative│ Ad block │
  │ DNSSEC           │ Yes          │ Yes          │ No       │
  │ Caching          │ Yes          │ Yes          │ Via FTL  │
  │ Ad blocking      │ Manual       │ No           │ Built-in │
  │ Privacy          │ Full (no fwd)│ N/A          │ Partial  │
  │ Complexity       │ Low          │ High         │ Low      │
  │ Resource usage   │ Very low     │ Medium       │ Low      │
  │ Best for         │ Privacy DNS  │ DNS hosting  │ Ad block │
  └──────────────────┴──────────────┴──────────────┴──────────┘

WHY UNBOUND:
  - No forwarding = no DNS provider sees your queries
  - DNSSEC validation = protection against DNS spoofing
  - Tiny footprint = runs on Raspberry Pi
  - Perfect partner for Pi-hole (Pi-hole → Unbound → root)

INSTALL:
  sudo apt install unbound
  # Config: /etc/unbound/unbound.conf
  # Service: systemctl enable --now unbound
  # Test: dig @127.0.0.1 example.com
EOF
}

cmd_config() {
cat << 'EOF'
UNBOUND.CONF
==============

BASIC RECURSIVE RESOLVER:
  server:
      interface: 0.0.0.0
      port: 5335
      do-ip4: yes
      do-ip6: no
      do-udp: yes
      do-tcp: yes

      # Access control
      access-control: 127.0.0.0/8 allow
      access-control: 10.0.0.0/8 allow
      access-control: 192.168.0.0/16 allow

      # Privacy & security
      hide-identity: yes
      hide-version: yes
      harden-glue: yes
      harden-dnssec-stripped: yes
      harden-referral-path: yes
      use-caps-for-id: yes          # 0x20 encoding (anti-spoof)
      val-clean-additional: yes

      # Performance
      num-threads: 4
      msg-cache-size: 64m
      rrset-cache-size: 128m
      cache-min-ttl: 300
      cache-max-ttl: 86400
      prefetch: yes                 # Prefetch expiring records
      prefetch-key: yes

      # DNSSEC (auto-trust-anchor)
      auto-trust-anchor-file: "/var/lib/unbound/root.key"

      # Logging
      verbosity: 1
      log-queries: no               # Enable for debugging only

FORWARDING MODE (use upstream DNS):
  # Use this if you DON'T want recursive resolution
  forward-zone:
      name: "."
      forward-tls-upstream: yes     # DNS-over-TLS
      # Cloudflare
      forward-addr: 1.1.1.1@853#cloudflare-dns.com
      forward-addr: 1.0.0.1@853#cloudflare-dns.com
      # Google
      forward-addr: 8.8.8.8@853#dns.google
      forward-addr: 8.8.4.4@853#dns.google

LOCAL ZONES (custom DNS records):
  server:
      # Block domains (ad blocking)
      local-zone: "doubleclick.net" refuse
      local-zone: "ads.example.com" refuse
      local-zone: "tracking.example.com" refuse

      # Custom local records
      local-data: "nas.home. A 192.168.1.100"
      local-data: "printer.home. A 192.168.1.50"
      local-data: "router.home. A 192.168.1.1"

      # Redirect domain
      local-zone: "example.test." redirect
      local-data: "example.test. A 10.0.0.5"

      # PTR records (reverse DNS)
      local-data-ptr: "192.168.1.100 nas.home."

PI-HOLE + UNBOUND:
  # 1. Unbound listens on port 5335
  # 2. Pi-hole forwards to 127.0.0.1#5335
  # 3. Unbound resolves recursively from root servers

  # Pi-hole settings:
  # Upstream DNS: 127.0.0.1#5335
  # Uncheck all other upstream DNS servers
EOF
}

cmd_operations() {
cat << 'EOF'
OPERATIONS & DNSSEC
======================

CLI TOOLS:
  unbound-control status           # Server status
  unbound-control stats_noreset    # Statistics
  unbound-control dump_cache       # Dump cache
  unbound-control load_cache       # Load cache from file
  unbound-control flush example.com    # Flush single domain
  unbound-control flush_zone com.      # Flush entire zone
  unbound-control flush_type A         # Flush by record type
  unbound-control reload               # Reload config
  unbound-control list_local_zones     # List local zones
  unbound-control list_forwards        # List forward zones

  # Enable remote control
  remote-control:
      control-enable: yes
      control-interface: 127.0.0.1
      control-port: 8953
  # Generate keys:
  unbound-control-setup

TESTING:
  # Basic query
  dig @127.0.0.1 -p 5335 example.com

  # DNSSEC validation
  dig @127.0.0.1 -p 5335 example.com +dnssec
  # Look for "ad" flag (Authenticated Data)

  # Test DNSSEC failure (should fail)
  dig @127.0.0.1 -p 5335 dnssec-failed.org
  # Should return SERVFAIL

  # Check QNAME minimization
  dig @127.0.0.1 -p 5335 example.com +qr
  # Shows individual queries to each level

  # Trace resolution path
  dig +trace example.com

DNSSEC:
  # How it works:
  # 1. Root zone signs .com NS records
  # 2. .com signs example.com NS records
  # 3. example.com signs its A/AAAA records
  # 4. Unbound validates entire chain

  # Key files
  /var/lib/unbound/root.key       # Root trust anchor
  # Auto-updated via RFC 5011 (auto-trust-anchor-file)

  # Manual root hints update
  wget -O /etc/unbound/root.hints https://www.internic.net/domain/named.root
  # Add to config:
  server:
      root-hints: "/etc/unbound/root.hints"

MONITORING:
  # Key metrics from stats
  unbound-control stats_noreset | grep -E "total|cache|num"
  #   total.num.queries        Total queries received
  #   total.num.cachehits      Cache hit count
  #   total.num.cachemiss      Cache miss count
  #   total.num.recursivereplies  Recursive queries made
  #   msg.cache.count          Cached messages
  #   rrset.cache.count        Cached RR sets

  # Prometheus exporter
  # github.com/letsencrypt/unbound_exporter
  # Exposes metrics at :9167/metrics

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Unbound - Recursive DNS Resolver Reference

Commands:
  intro       Architecture, vs BIND/Pi-hole
  config      unbound.conf, forwarding, local zones
  operations  CLI tools, DNSSEC, monitoring

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  config)     cmd_config ;;
  operations) cmd_operations ;;
  help|*)     show_help ;;
esac
