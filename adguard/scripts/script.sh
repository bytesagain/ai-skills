#!/bin/bash
# AdGuard Home DNS Filtering & Network Protection Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ADGUARD HOME REFERENCE                         ║
║          Network-wide Ad Blocking & DNS Privacy             ║
╚══════════════════════════════════════════════════════════════╝

AdGuard Home is a network-wide software for blocking ads and tracking.
It operates as a DNS sinkhole, intercepting DNS queries and filtering
out unwanted domains before they reach your devices.

KEY FEATURES:
  DNS Filtering    Block ads, trackers, malware at DNS level
  DNS Privacy      DNS-over-HTTPS (DoH), DNS-over-TLS (DoT), DNSCrypt
  DHCP Server      Built-in DHCP, can replace your router's
  Query Log        Full DNS query history with analytics
  Parental Control Time-based and category-based filtering
  Safe Browsing    Block phishing and malware domains
  Custom Rules     AdBlock-style filtering syntax
  Client Settings  Per-device filtering policies

ADGUARD vs PI-HOLE:
  ┌─────────────────┬──────────────┬──────────────┐
  │ Feature         │ AdGuard Home │ Pi-hole      │
  ├─────────────────┼──────────────┼──────────────┤
  │ DoH/DoT/QUIC   │ Built-in     │ Plugin       │
  │ DHCP Server     │ Built-in     │ Built-in     │
  │ Parental        │ Built-in     │ No           │
  │ Safe Browsing   │ Built-in     │ No           │
  │ Per-client      │ Built-in     │ Group mgmt   │
  │ UI              │ Modern React │ PHP          │
  │ Memory          │ ~30MB        │ ~80MB        │
  │ Language        │ Go           │ Shell/PHP    │
  │ Platforms       │ Any OS       │ Linux only   │
  └─────────────────┴──────────────┴──────────────┘

ARCHITECTURE:
  Client devices → AdGuard Home (DNS) → Upstream DNS servers
                      │
                      ├── Blocklists (filter domains)
                      ├── Custom rules (user overrides)
                      ├── Safe browsing check
                      └── Query log & statistics
EOF
}

cmd_install() {
cat << 'EOF'
ADGUARD HOME INSTALLATION
===========================

1. AUTOMATED INSTALL (Recommended)
   curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v

   This installs to /opt/AdGuardHome/ and creates a systemd service.

2. DOCKER
   docker run -d \
     --name adguardhome \
     --restart=always \
     -v /opt/adguard/work:/opt/adguardhome/work \
     -v /opt/adguard/conf:/opt/adguardhome/conf \
     -p 53:53/tcp -p 53:53/udp \
     -p 3000:3000/tcp \
     -p 853:853/tcp \
     -p 443:443/tcp \
     adguard/adguardhome

   Docker Compose:
     version: '3'
     services:
       adguardhome:
         image: adguard/adguardhome
         restart: always
         ports:
           - "53:53/tcp"
           - "53:53/udp"
           - "3000:3000"
           - "853:853"
         volumes:
           - ./work:/opt/adguardhome/work
           - ./conf:/opt/adguardhome/conf

3. INITIAL SETUP
   - Open http://<server-ip>:3000
   - Set admin username and password
   - Configure listen interfaces
   - Set upstream DNS servers
   - DNS listen port defaults to 53

4. POST-INSTALL
   Point your router's DNS to AdGuard Home IP.
   Or: configure individual devices DNS settings.
   Or: use AdGuard Home's built-in DHCP server.

   Verify it works:
     nslookup doubleclick.net <adguard-ip>
     # Should return 0.0.0.0 (blocked)

SYSTEM REQUIREMENTS:
  RAM:    ~30MB idle, ~100MB under load
  CPU:    Minimal (ARM works fine)
  Disk:   ~50MB + query logs
  Ports:  53 (DNS), 3000 (Web UI), 853 (DoT), 443 (DoH)
EOF
}

cmd_filtering() {
cat << 'EOF'
DNS FILTERING & BLOCKLISTS
============================

BUILT-IN FILTERS:
  AdGuard DNS filter      Default, maintained by AdGuard team
  AdAway Default          Mobile-focused ad blocking
  MalwareDomainList       Known malware domains
  Dan Pollock's hosts     Community-maintained

RECOMMENDED BLOCKLISTS:
  # Ads
  https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt
  https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts

  # Tracking
  https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt
  https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt

  # Malware
  https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt
  https://urlhaus.abuse.ch/downloads/hostfile/

  # Chinese ads (for CN users)
  https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-easylist.txt

FILTER SYNTAX (AdBlock-style):
  ||example.com^          Block example.com and all subdomains
  @@||example.com^        Whitelist (unblock) example.com
  /regex/                 Block domains matching regex
  ||ads.*/^               Block any domain starting with "ads."
  127.0.0.1 example.com   Hosts-file format (also supported)

CUSTOM RULES EXAMPLES:
  # Block Facebook tracking
  ||facebook.com^$important
  ||fbcdn.net^
  ||facebook.net^
  @@||www.facebook.com^    # But allow the site itself

  # Block telemetry
  ||telemetry.microsoft.com^
  ||vortex.data.microsoft.com^
  ||settings-win.data.microsoft.com^

  # Block smart TV ads
  ||ads.samsung.com^
  ||lgtvsdp.com^
  ||samsungads.com^

  # Allow specific service through blocklist
  @@||ads.google.com^      # Needed for Google Shopping

FILTERING BEST PRACTICES:
  - Start with default AdGuard DNS filter
  - Add one list at a time, test for breakage
  - Use the query log to find false positives
  - Whitelist before removing entire blocklists
  - Total domains blocked: aim for 100K-500K (more can slow queries)
  - Update filters every 12-24 hours
EOF
}

cmd_dns_privacy() {
cat << 'EOF'
DNS PRIVACY PROTOCOLS
======================

1. DNS-OVER-HTTPS (DoH)
   Encrypts DNS queries in HTTPS traffic on port 443.

   AdGuard Home config (AdGuardHome.yaml):
     tls:
       enabled: true
       server_name: dns.example.com
       port_https: 443
       port_dns_over_tls: 853
       certificate_path: /path/to/fullchain.pem
       private_key_path: /path/to/privkey.pem

   Client configuration:
     Firefox: Settings → Network → Enable DNS over HTTPS
              URL: https://dns.example.com/dns-query
     Chrome:  Settings → Security → Use secure DNS
              Custom: https://dns.example.com/dns-query
     Windows: Settings → Network → DNS → DNS over HTTPS

2. DNS-OVER-TLS (DoT)
   Dedicated TLS connection on port 853.

   Client configuration:
     Android 9+: Settings → Network → Private DNS
                  dns.example.com
     systemd-resolved:
       [Resolve]
       DNS=<adguard-ip>#dns.example.com
       DNSOverTLS=yes

3. DNS-OVER-QUIC (DoQ)
   Newest protocol, uses QUIC (UDP-based).
   Lower latency than DoH/DoT.

   AdGuard Home supports DoQ on port 853 (shared with DoT).
   URL: quic://dns.example.com

4. DNSCRYPT
   Older but proven encryption protocol.
   Enable in AdGuard Home settings.

UPSTREAM DNS CONFIGURATION:
  Plain DNS:
    8.8.8.8                 Google
    1.1.1.1                 Cloudflare
    9.9.9.9                 Quad9

  DNS-over-HTTPS:
    https://dns.google/dns-query
    https://cloudflare-dns.com/dns-query
    https://dns.quad9.net/dns-query

  DNS-over-TLS:
    tls://dns.google
    tls://1dot1dot1dot1.cloudflare-dns.com
    tls://dns.quad9.net

  DNS-over-QUIC:
    quic://dns.adguard-dns.com

BOOTSTRAP DNS:
  When upstream is DoH/DoT, you need bootstrap DNS to resolve
  the upstream hostname itself:
    bootstrap_dns:
      - 1.1.1.1
      - 8.8.8.8

PERFORMANCE TIP:
  Use parallel upstream queries:
    upstream_dns:
      - https://dns.google/dns-query
      - https://cloudflare-dns.com/dns-query
    all_servers: true     # Query all, use fastest response
EOF
}

cmd_clients() {
cat << 'EOF'
PER-CLIENT CONFIGURATION
==========================

AdGuard Home can apply different filtering rules per device.

CLIENT IDENTIFICATION:
  By IP address:     192.168.1.100
  By IP range:       192.168.1.100-192.168.1.200
  By CIDR:           192.168.1.0/24
  By MAC address:    aa:bb:cc:dd:ee:ff
  By Client ID:      Used with DoH/DoT (dns.example.com/dns-query/client-id)

SETTING UP CLIENTS:

  1. Go to Settings → Client Settings
  2. Add a persistent client
  3. Configure:
     - Name: "Kids iPad"
     - Identifiers: 192.168.1.50
     - Use global settings / Override:
       ☐ Block adult websites
       ☐ Enforce Safe Search
       ☐ Use custom upstream DNS
       ☐ Apply specific blocklists

PER-CLIENT USE CASES:

  Kids' devices:
    - Enable Parental Control
    - Enable Safe Search on Google/YouTube/Bing
    - Add schedule: block social media 22:00-08:00
    - Extra blocklist: adult content filter

  Work devices:
    - Minimal filtering (ads only)
    - No parental controls
    - Allow analytics/tracking (might need for work)

  IoT devices:
    - Strict filtering
    - Block telemetry aggressively
    - Monitor query log for suspicious activity

  Guest network:
    - Default filtering
    - Block known malware
    - Enable Safe Browsing

CLIENT ID FOR ENCRYPTED DNS:
  When using DoH/DoT, IP-based identification doesn't work
  if queries come through a proxy. Use Client IDs instead:

  DoH: https://dns.example.com/dns-query/johns-laptop
  DoT: johns-laptop.dns.example.com

  Configure in client:
    Firefox DoH URL: https://dns.example.com/dns-query/johns-laptop
EOF
}

cmd_dhcp() {
cat << 'EOF'
BUILT-IN DHCP SERVER
======================

AdGuard Home includes a DHCP server, useful when your router doesn't
allow changing DNS settings.

SETUP:
  1. Disable your router's DHCP server first
  2. Go to Settings → DHCP Settings
  3. Configure:
     Interface:   eth0 (select your LAN interface)
     Gateway IP:  192.168.1.1 (your router)
     Subnet mask: 255.255.255.0
     IP range:    192.168.1.100 - 192.168.1.250
     Lease time:  24h

  4. Enable DHCP server
  5. Renew DHCP lease on all clients:
     # Windows:  ipconfig /release && ipconfig /renew
     # macOS:    sudo ipconfig set en0 DHCP
     # Linux:    sudo dhclient -r && sudo dhclient

STATIC LEASES:
  Assign fixed IPs to specific devices by MAC address.
  Useful for:
  - Servers that need consistent IPs
  - IoT devices you want to track
  - Per-client filtering rules

  Settings → DHCP → Static Leases → Add:
    MAC:      aa:bb:cc:dd:ee:ff
    IP:       192.168.1.10
    Hostname: homeserver

DHCPv6:
  Also supported. Enable in DHCP settings.
  Uses router advertisement (RA) for address assignment.

TROUBLESHOOTING DHCP:
  - Only ONE DHCP server per network segment
  - If both router and AdGuard serve DHCP → IP conflicts
  - Check leases: Settings → DHCP → DHCP leases
  - Check interface binding: must be the LAN-facing interface
  - Firewall: allow UDP 67/68 (DHCP)
EOF
}

cmd_api() {
cat << 'EOF'
ADGUARD HOME API
==================

AdGuard Home has a REST API for automation.

AUTHENTICATION:
  Basic Auth with admin credentials.
  curl -u admin:password http://adguard:3000/control/status

STATUS:
  GET /control/status
  Response:
    {
      "dns_addresses": ["0.0.0.0"],
      "dns_port": 53,
      "http_port": 3000,
      "protection_enabled": true,
      "running": true,
      "version": "0.107.44"
    }

QUERY LOG:
  GET /control/querylog?limit=100&offset=0
  Returns recent DNS queries with:
  - Client IP, queried domain, answer, filter applied
  - Useful for monitoring and debugging

FILTERING:
  # Enable/disable protection
  POST /control/dns_config
  {"protection_enabled": true}

  # Add filtering rule
  POST /control/filtering/add_url
  {"name": "My List", "url": "https://example.com/blocklist.txt", "whitelist": false}

  # Refresh filters
  POST /control/filtering/refresh
  {"whitelist": false}

  # Check if domain is filtered
  GET /control/filtering/check_host?name=doubleclick.net

STATISTICS:
  GET /control/stats
  Response:
    {
      "num_dns_queries": 145230,
      "num_blocked_filtering": 28450,
      "num_replaced_safebrowsing": 12,
      "num_replaced_parental": 0,
      "avg_processing_time": 0.023
    }

CLIENTS:
  # List persistent clients
  GET /control/clients

  # Add client
  POST /control/clients/add
  {
    "name": "Kids iPad",
    "ids": ["192.168.1.50"],
    "use_global_settings": false,
    "filtering_enabled": true,
    "parental_enabled": true,
    "safesearch_enabled": true
  }

DHCP:
  GET /control/dhcp/status
  POST /control/dhcp/set_config
  POST /control/dhcp/add_static_lease

AUTOMATION EXAMPLE:
  #!/bin/bash
  # Block a domain across all clients
  ADGUARD="http://192.168.1.2:3000"
  AUTH="admin:password"

  curl -s -u "$AUTH" -X POST "$ADGUARD/control/filtering/set_rules" \
    -H "Content-Type: application/json" \
    -d '{"rules": ["||malware-site.com^"]}'

  echo "Domain blocked."
EOF
}

cmd_best_practices() {
cat << 'EOF'
ADGUARD HOME BEST PRACTICES
==============================

1. PLACEMENT
   Best: Run on dedicated device (Raspberry Pi, small VPS)
   Good: Run on always-on server/NAS
   Avoid: Running on a laptop (goes offline when closed)

   Network placement:
   - Between router and devices (as DNS server)
   - Use DHCP to auto-configure all devices
   - Keep AdGuard on wired connection (not WiFi)

2. PERFORMANCE
   - DNS cache: enabled by default, increase for large networks
   - Optimistic caching: serve stale cache while refreshing
   - Rate limiting: protect against DNS amplification
   - Use compiled blocklists over many small lists

   AdGuardHome.yaml tuning:
     dns:
       cache_size: 10000000      # ~10MB cache
       cache_ttl_min: 600        # Minimum 10min TTL
       cache_ttl_max: 86400      # Maximum 24h TTL
       cache_optimistic: true    # Serve stale while refreshing
       ratelimit: 100            # Queries/sec per client

3. SECURITY
   - Change default admin password immediately
   - Enable HTTPS for web interface
   - Restrict web UI to LAN only (or VPN)
   - Enable encrypted DNS (DoH/DoT) for upstream
   - Monitor query log for suspicious patterns
   - Keep AdGuard Home updated

4. HIGH AVAILABILITY
   Run two instances:
   - Primary: 192.168.1.2
   - Secondary: 192.168.1.3
   - DHCP: set both as DNS servers
   - Sync config between them (API or shared config)

5. MONITORING
   - Check blocked percentage (healthy: 15-40%)
   - Monitor top blocked domains for false positives
   - Watch for devices bypassing DNS (use firewall rules)
   - Alert on service downtime

   Firewall: force all DNS through AdGuard:
     iptables -t nat -A PREROUTING -i eth0 -p udp --dport 53 \
       -j DNAT --to 192.168.1.2:53
     iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 53 \
       -j DNAT --to 192.168.1.2:53

6. BACKUP
   Back up /opt/AdGuardHome/AdGuardHome.yaml
   Contains all settings, filters, clients, custom rules.

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
AdGuard Home DNS Filtering & Network Protection Reference

Commands:
  intro           Overview and comparison with Pi-hole
  install         Installation (native, Docker) and initial setup
  filtering       Blocklists, filter syntax, and custom rules
  dns-privacy     DoH, DoT, DoQ, DNSCrypt configuration
  clients         Per-device filtering and client policies
  dhcp            Built-in DHCP server setup
  api             REST API for automation and monitoring
  best-practices  Deployment, security, and performance tuning

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)           cmd_intro ;;
  install)         cmd_install ;;
  filtering)       cmd_filtering ;;
  dns-privacy)     cmd_dns_privacy ;;
  clients)         cmd_clients ;;
  dhcp)            cmd_dhcp ;;
  api)             cmd_api ;;
  best-practices)  cmd_best_practices ;;
  help|*)          show_help ;;
esac
