#!/bin/bash
# BIND - DNS Server Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              BIND 9 REFERENCE                               ║
║          The Most Widely Used DNS Server                    ║
╚══════════════════════════════════════════════════════════════╝

BIND (Berkeley Internet Name Domain) is the reference implementation
of DNS. BIND 9 serves the majority of DNS infrastructure worldwide.

ROLES:
  Authoritative    Answer queries for zones you own
  Recursive        Resolve queries by querying other DNS servers
  Forwarder        Forward queries to upstream resolvers
  Secondary        Slave copy of a primary zone (zone transfer)
  Caching          Cache resolved queries for performance

KEY FILES:
  /etc/named.conf              Main configuration
  /etc/named/                  Zone files directory
  /var/named/                  Zone data (RHEL/CentOS)
  /etc/bind/named.conf         Debian/Ubuntu config
  /var/cache/bind/             Debian zone data

RECORD TYPES:
  A        IPv4 address          example.com → 93.184.216.34
  AAAA     IPv6 address          example.com → 2606:2800:220:1:248:...
  CNAME    Canonical name alias  www → example.com
  MX       Mail exchange         example.com → mail.example.com (pri 10)
  NS       Name server           example.com → ns1.example.com
  TXT      Text record           SPF, DKIM, DMARC, verification
  SOA      Start of authority    Zone metadata (serial, refresh, retry)
  SRV      Service location      _sip._tcp → sipserver:5060
  PTR      Reverse DNS           34.216.184.93 → example.com
  CAA      CA Authorization      Restrict certificate issuance
EOF
}

cmd_config() {
cat << 'EOF'
NAMED.CONF CONFIGURATION
===========================

BASIC RECURSIVE RESOLVER:
  options {
      listen-on port 53 { any; };
      listen-on-v6 port 53 { any; };
      directory "/var/named";
      recursion yes;
      allow-recursion { 192.168.0.0/16; 10.0.0.0/8; localhost; };
      forwarders {
          1.1.1.1;
          8.8.8.8;
      };
      forward only;
      dnssec-validation auto;
      max-cache-size 256m;
  };

BASIC AUTHORITATIVE SERVER:
  options {
      listen-on port 53 { any; };
      directory "/var/named";
      recursion no;
      allow-transfer { 10.0.0.2; };  // Secondary server IP
  };

  zone "example.com" IN {
      type master;
      file "example.com.zone";
      allow-update { none; };
  };

  zone "168.192.in-addr.arpa" IN {
      type master;
      file "192.168.rev";
  };

SECONDARY (SLAVE) SERVER:
  zone "example.com" IN {
      type slave;
      masters { 10.0.0.1; };
      file "slaves/example.com.zone";
  };

ACL DEFINITIONS:
  acl "internal" {
      192.168.0.0/16;
      10.0.0.0/8;
      172.16.0.0/12;
      localhost;
  };

  options {
      allow-query { internal; };
      allow-recursion { internal; };
  };

VIEWS (split DNS):
  view "internal" {
      match-clients { internal; };
      recursion yes;

      zone "example.com" {
          type master;
          file "example.com.internal.zone";
      };
  };

  view "external" {
      match-clients { any; };
      recursion no;

      zone "example.com" {
          type master;
          file "example.com.external.zone";
      };
  };

LOGGING:
  logging {
      channel default_log {
          file "/var/log/named/default.log" versions 3 size 5m;
          severity info;
          print-time yes;
          print-severity yes;
      };
      channel query_log {
          file "/var/log/named/query.log" versions 5 size 10m;
          severity debug;
          print-time yes;
      };
      category default { default_log; };
      category queries { query_log; };
  };
EOF
}

cmd_zones() {
cat << 'EOF'
ZONE FILES
============

FORWARD ZONE (example.com.zone):
  $TTL 86400
  @   IN  SOA ns1.example.com. admin.example.com. (
              2026032401  ; Serial (YYYYMMDDNN)
              3600        ; Refresh (1 hour)
              900         ; Retry (15 min)
              604800      ; Expire (1 week)
              86400       ; Minimum TTL (1 day)
          )

  ; Name Servers
  @       IN  NS      ns1.example.com.
  @       IN  NS      ns2.example.com.

  ; A Records
  @       IN  A       93.184.216.34
  ns1     IN  A       10.0.0.1
  ns2     IN  A       10.0.0.2
  www     IN  A       93.184.216.34
  mail    IN  A       93.184.216.35
  api     IN  A       93.184.216.36

  ; AAAA Records
  @       IN  AAAA    2606:2800:220:1:248:1893:25c8:1946

  ; CNAME Records
  blog    IN  CNAME   www.example.com.
  ftp     IN  CNAME   www.example.com.

  ; MX Records
  @       IN  MX  10  mail.example.com.
  @       IN  MX  20  backup-mail.example.com.

  ; TXT Records
  @       IN  TXT     "v=spf1 mx a ip4:93.184.216.0/24 -all"
  _dmarc  IN  TXT     "v=DMARC1; p=reject; rua=mailto:dmarc@example.com"

  ; SRV Records
  _sip._tcp  IN  SRV  10 60 5060 sip.example.com.

  ; CAA Records
  @       IN  CAA  0 issue "letsencrypt.org"

REVERSE ZONE (192.168.1.rev):
  $TTL 86400
  @   IN  SOA ns1.example.com. admin.example.com. (
              2026032401 3600 900 604800 86400
          )
  @       IN  NS  ns1.example.com.
  @       IN  NS  ns2.example.com.

  1       IN  PTR gateway.example.com.
  10      IN  PTR server1.example.com.
  11      IN  PTR server2.example.com.
  100     IN  PTR workstation1.example.com.

SERIAL NUMBER CONVENTION:
  YYYYMMDDNN  where NN = change number that day
  2026032401  = March 24, 2026, first change
  2026032402  = March 24, 2026, second change

  CRITICAL: Always increment serial on every zone change!
  Secondaries use serial to detect updates.

WILDCARD RECORDS:
  *.example.com.  IN  A  93.184.216.34
  ; Matches any subdomain not explicitly defined
EOF
}

cmd_security() {
cat << 'EOF'
DNSSEC & SECURITY
===================

DNSSEC OVERVIEW:
  DNSSEC adds cryptographic signatures to DNS records,
  preventing spoofing and cache poisoning.

  Chain of trust: Root → TLD → Your zone
  Key types: KSK (Key Signing Key) + ZSK (Zone Signing Key)

ENABLE DNSSEC:
  # Generate keys
  dnssec-keygen -a ECDSAP256SHA256 -b 256 -n ZONE example.com    # ZSK
  dnssec-keygen -a ECDSAP256SHA256 -b 256 -n ZONE -f KSK example.com  # KSK

  # Sign zone
  dnssec-signzone -A -3 $(head -c 16 /dev/random | od -An -tx1 | tr -d ' ') \
    -N INCREMENT -o example.com -t example.com.zone

  # Update named.conf to use signed zone
  zone "example.com" {
      type master;
      file "example.com.zone.signed";
      key-directory "/etc/named/keys";
      auto-dnssec maintain;
      inline-signing yes;
  };

DNSSEC VALIDATION (resolver side):
  options {
      dnssec-validation auto;
      # Uses built-in root trust anchors
  };

  # Test DNSSEC
  dig +dnssec example.com
  # Look for "ad" flag (Authenticated Data)

RATE LIMITING:
  options {
      rate-limit {
          responses-per-second 10;
          window 5;
          slip 2;
          log-only no;
      };
  };

HARDENING CHECKLIST:
  ☐ Restrict recursion to trusted networks
  ☐ Hide version: version "not disclosed";
  ☐ Disable zone transfers except to secondaries
  ☐ Enable DNSSEC validation
  ☐ Set up rate limiting
  ☐ Use minimal responses: minimal-responses yes;
  ☐ Run as non-root user
  ☐ Chroot: named -t /var/named/chroot
  ☐ Monitor query logs for anomalies

RESPONSE POLICY ZONES (RPZ):
  Block malicious domains at DNS level.

  zone "rpz.example.com" {
      type master;
      file "rpz.zone";
  };

  # rpz.zone
  malware-domain.com  CNAME .        ; Block (NXDOMAIN)
  phishing-site.net   A 127.0.0.1    ; Redirect to sinkhole
  *.bad-domain.org    CNAME .        ; Block all subdomains
EOF
}

cmd_troubleshoot() {
cat << 'EOF'
TROUBLESHOOTING & TOOLS
==========================

DIAGNOSTIC COMMANDS:
  # Check config syntax
  named-checkconf /etc/named.conf

  # Check zone file syntax
  named-checkzone example.com /var/named/example.com.zone

  # Query local server
  dig @localhost example.com A
  dig @localhost example.com MX
  dig @localhost example.com ANY +noall +answer

  # Trace resolution path
  dig +trace example.com

  # Query specific record type
  dig example.com AAAA +short
  dig _dmarc.example.com TXT +short

  # Reverse lookup
  dig -x 93.184.216.34

  # Check DNSSEC
  dig +dnssec +multi example.com DNSKEY

  # BIND status
  rndc status
  rndc reload                    # Reload all zones
  rndc reload example.com        # Reload specific zone
  rndc flush                     # Flush cache
  rndc dumpdb -cache             # Dump cache to file
  rndc querylog on               # Enable query logging

COMMON ISSUES:

  "zone not loaded":
    → Check named-checkzone output
    → Verify serial number incremented
    → Check file permissions

  "REFUSED":
    → allow-query / allow-recursion doesn't include client
    → Recursion disabled but client sending recursive query

  "SERVFAIL":
    → DNSSEC validation failure
    → Upstream server unreachable
    → Zone file syntax error

  "Transfer failed":
    → Check allow-transfer ACL on primary
    → Verify secondary can reach primary port 53
    → Check serial numbers (secondary must be lower)

  Slow resolution:
    → Check forwarders are responsive
    → Check if rate limiting is too aggressive
    → Look for DNSSEC validation delays
    → Verify network connectivity to root servers

PERFORMANCE TUNING:
  options {
      max-cache-size 512m;          # Increase cache
      max-cache-ttl 86400;          # Max cache TTL (1 day)
      max-ncache-ttl 3600;          # Max negative cache (1 hour)
      recursive-clients 10000;       # Max concurrent recursive
      tcp-clients 1000;             # Max TCP connections
      cleaning-interval 60;          # Cache cleanup interval
  };

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
BIND 9 - DNS Server Reference

Commands:
  intro          DNS concepts, record types, server roles
  config         named.conf, ACLs, views, logging
  zones          Zone files, records, serial numbers, wildcards
  security       DNSSEC, rate limiting, RPZ, hardening
  troubleshoot   dig, rndc, common errors, performance

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)        cmd_intro ;;
  config)       cmd_config ;;
  zones)        cmd_zones ;;
  security)     cmd_security ;;
  troubleshoot) cmd_troubleshoot ;;
  help|*)       show_help ;;
esac
