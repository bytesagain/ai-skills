#!/bin/bash
# Squid - Forward Proxy & Web Cache Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              SQUID REFERENCE                                ║
║          Forward Proxy, Web Cache & Content Filter          ║
╚══════════════════════════════════════════════════════════════╝

Squid is a caching and forwarding HTTP web proxy. Unlike Varnish
(reverse proxy), Squid sits between users and the internet
as a forward proxy — filtering, caching, and controlling access.

SQUID vs VARNISH:
  ┌──────────────────┬──────────────┬──────────────┐
  │ Feature          │ Squid        │ Varnish      │
  ├──────────────────┼──────────────┼──────────────┤
  │ Direction        │ Forward proxy│ Reverse proxy│
  │ Who uses it      │ Clients      │ Servers      │
  │ Purpose          │ Filter/cache │ Accelerate   │
  │ HTTPS            │ CONNECT/bump │ Terminate    │
  │ Auth             │ LDAP/RADIUS  │ None         │
  │ ACLs             │ Extensive    │ VCL          │
  │ Best for         │ Corp network │ Web backend  │
  └──────────────────┴──────────────┴──────────────┘

USE CASES:
  Corporate proxy     Control employee internet access
  Content filtering   Block malware, ads, adult content
  Bandwidth saving    Cache frequently accessed content
  Access logging      Audit who visits what
  Transparent proxy   Intercept all HTTP without config
  SSL inspection      HTTPS content filtering (bump)

INSTALL:
  sudo apt install squid
  # Config: /etc/squid/squid.conf
  # Default port: 3128
  # Cache dir: /var/spool/squid
EOF
}

cmd_config() {
cat << 'EOF'
SQUID.CONF
============

BASIC CONFIG:
  # Listen port
  http_port 3128

  # Transparent proxy (intercept mode)
  http_port 3129 intercept

  # ACL definitions
  acl localnet src 10.0.0.0/8
  acl localnet src 172.16.0.0/12
  acl localnet src 192.168.0.0/16
  acl SSL_ports port 443
  acl Safe_ports port 80 443 21 70 210 280 488 591 777 1025-65535

  # Access rules (order matters!)
  http_access deny !Safe_ports
  http_access deny CONNECT !SSL_ports
  http_access allow localnet
  http_access deny all

CACHE SETTINGS:
  # Memory cache (RAM)
  cache_mem 512 MB

  # Disk cache (2GB, L1=16 dirs, L2=256 dirs)
  cache_dir ufs /var/spool/squid 2048 16 256

  # Max cached object size
  maximum_object_size 100 MB
  maximum_object_size_in_memory 10 MB

  # Cache replacement policy
  cache_replacement_policy heap LFUDA
  memory_replacement_policy heap GDSF

  # Don't cache dynamic content
  acl dynamic urlpath_regex cgi-bin \?
  cache deny dynamic

  # Cache static content aggressively
  refresh_pattern -i \.(jpg|png|gif|css|js)$ 10080 90% 43200

CONTENT FILTERING:
  # Block domains
  acl blocked_sites dstdomain .facebook.com .youtube.com .tiktok.com
  http_access deny blocked_sites

  # Block by URL regex
  acl blocked_urls url_regex -i gambling porn torrent
  http_access deny blocked_urls

  # Block file types
  acl blocked_files urlpath_regex -i \.(exe|bat|cmd|msi|torrent)$
  http_access deny blocked_files

  # Time-based access
  acl work_hours time MTWHF 09:00-17:00
  acl social_media dstdomain .twitter.com .instagram.com
  http_access deny social_media !work_hours

  # Blocklist file
  acl blocked_list dstdomain "/etc/squid/blocked.txt"
  http_access deny blocked_list
EOF
}

cmd_operations() {
cat << 'EOF'
AUTHENTICATION, SSL & MONITORING
====================================

AUTHENTICATION:
  # Basic auth (htpasswd)
  auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
  auth_param basic children 5
  auth_param basic realm Proxy Authentication
  auth_param basic credentialsttl 2 hours
  acl authenticated proxy_auth REQUIRED
  http_access allow authenticated

  # LDAP auth
  auth_param basic program /usr/lib/squid/basic_ldap_auth \
    -b "dc=example,dc=com" -f "uid=%s" -h ldap.example.com
  acl ldap_users proxy_auth REQUIRED
  http_access allow ldap_users

SSL BUMP (HTTPS inspection):
  # Generate CA cert
  openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
    -keyout /etc/squid/squid-ca-key.pem \
    -out /etc/squid/squid-ca-cert.pem

  # squid.conf
  http_port 3128 ssl-bump \
    cert=/etc/squid/squid-ca-cert.pem \
    key=/etc/squid/squid-ca-key.pem \
    generate-host-certificates=on
  sslcrtd_program /usr/lib/squid/security_file_certgen -s /var/lib/squid/ssl -M 4MB

  acl step1 at_step SslBump1
  ssl_bump peek step1
  ssl_bump bump all

  # WARNING: SSL bump breaks end-to-end encryption
  # Install squid-ca-cert.pem on all client machines

MONITORING:
  # Access log
  access_log daemon:/var/log/squid/access.log squid

  # Cache manager (built-in web UI)
  http_port 3128
  cachemgr_passwd secret all
  # http://proxy:3128/squid-internal-mgr/

  # Useful cache manager pages:
  # /squid-internal-mgr/info          Server info
  # /squid-internal-mgr/utilization   Cache utilization
  # /squid-internal-mgr/active_requests Active connections

  # CLI tools
  squidclient -p 3128 mgr:info        # Server info
  squidclient -p 3128 mgr:utilization  # Cache stats
  squidclient -p 3128 -m PURGE http://example.com/page  # Purge URL

  # Log analysis
  # Top domains
  awk '{print $7}' /var/log/squid/access.log | \
    sed 's|https\?://||;s|/.*||' | sort | uniq -c | sort -rn | head -20

  # Cache hit ratio
  squidclient -p 3128 mgr:info | grep "Request Hit Ratios"

  # Reload config without restart
  squid -k reconfigure

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Squid - Forward Proxy & Web Cache Reference

Commands:
  intro       Architecture, vs Varnish, use cases
  config      squid.conf, ACLs, caching, content filter
  operations  Auth, SSL inspection, monitoring

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  config)     cmd_config ;;
  operations) cmd_operations ;;
  help|*)     show_help ;;
esac
