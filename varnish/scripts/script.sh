#!/bin/bash
# Varnish - HTTP Accelerator & Caching Proxy Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              VARNISH REFERENCE                              ║
║          HTTP Accelerator & Reverse Proxy Cache             ║
╚══════════════════════════════════════════════════════════════╝

Varnish Cache is a web application accelerator (reverse proxy
cache). It sits between clients and your web server, caching
responses in memory for sub-millisecond delivery.

VARNISH vs NGINX CACHING vs CDN:
  ┌──────────────────┬──────────────┬──────────────┬──────────┐
  │ Feature          │ Varnish      │ Nginx cache  │ CDN      │
  ├──────────────────┼──────────────┼──────────────┼──────────┤
  │ Flexibility      │ VCL (code)   │ Config       │ Config   │
  │ Cache logic      │ Programmable │ Rule-based   │ Rule     │
  │ Location         │ Origin edge  │ Origin       │ Global   │
  │ Speed            │ Sub-ms       │ ~1ms         │ Varies   │
  │ ESI support      │ Yes          │ No           │ Some     │
  │ Grace mode       │ Yes          │ Limited      │ No       │
  │ Purge control    │ Full         │ Basic        │ API      │
  │ Best for         │ Dynamic sites│ Static       │ Global   │
  └──────────────────┴──────────────┴──────────────┴──────────┘

ARCHITECTURE:
  Client → Varnish (port 80) → Backend (port 8080)
           ↓ cache hit?
           ├─ YES → serve from RAM (sub-ms)
           └─ NO  → fetch from backend → cache → serve

INSTALL:
  sudo apt install varnish
  # Default: listens on port 6081, backend on port 8080
  # Config: /etc/varnish/default.vcl
EOF
}

cmd_vcl() {
cat << 'EOF'
VCL CONFIGURATION LANGUAGE
=============================

VCL (Varnish Configuration Language) is a domain-specific
language for controlling caching behavior. It compiles to C.

BASIC VCL:
  vcl 4.1;

  backend default {
      .host = "127.0.0.1";
      .port = "8080";
      .connect_timeout = 5s;
      .first_byte_timeout = 30s;
      .between_bytes_timeout = 10s;
  }

  # Multiple backends + health checks
  backend web1 {
      .host = "10.0.0.1";
      .port = "8080";
      .probe = {
          .url = "/health";
          .interval = 5s;
          .timeout = 2s;
          .threshold = 3;
          .window = 5;
      }
  }

  backend web2 {
      .host = "10.0.0.2";
      .port = "8080";
      .probe = { .url = "/health"; .interval = 5s; }
  }

  # Load balancing
  import directors;
  sub vcl_init {
      new cluster = directors.round_robin();
      cluster.add_backend(web1);
      cluster.add_backend(web2);
  }
  sub vcl_recv {
      set req.backend_hint = cluster.backend();
  }

VCL SUBROUTINES (request lifecycle):
  vcl_recv        → Receives request, decide cache/pass/pipe
  vcl_hash        → Build cache key
  vcl_hit         → Cache hit, decide deliver/restart
  vcl_miss        → Cache miss, decide fetch/error
  vcl_backend_response → Backend responded, decide cache/don't
  vcl_deliver     → About to deliver to client, modify headers

CACHING RULES:
  sub vcl_recv {
      # Don't cache POST requests
      if (req.method == "POST") { return (pass); }

      # Don't cache authenticated requests
      if (req.http.Authorization || req.http.Cookie ~ "session") {
          return (pass);
      }

      # Strip tracking params for better cache hit rate
      set req.url = regsuball(req.url, "[?&](utm_[a-z]+|fbclid|gclid)=[^&]*", "");

      # Force cache for static assets
      if (req.url ~ "\.(css|js|jpg|png|gif|svg|woff2?)$") {
          unset req.http.Cookie;
          return (hash);
      }
  }

  sub vcl_backend_response {
      # Cache static assets for 1 day
      if (bereq.url ~ "\.(css|js|jpg|png|gif|svg)$") {
          set beresp.ttl = 1d;
          unset beresp.http.Set-Cookie;
      }

      # Don't cache 500 errors
      if (beresp.status >= 500) {
          set beresp.uncacheable = true;
          set beresp.ttl = 10s;
          return (deliver);
      }

      # Grace mode: serve stale content while fetching
      set beresp.grace = 24h;
  }

  sub vcl_deliver {
      # Add debug header
      if (obj.hits > 0) {
          set resp.http.X-Cache = "HIT (" + obj.hits + ")";
      } else {
          set resp.http.X-Cache = "MISS";
      }
  }
EOF
}

cmd_operations() {
cat << 'EOF'
OPERATIONS & PURGING
======================

CLI TOOLS:
  varnishstat              # Real-time statistics
  varnishlog               # Detailed request log
  varnishtop               # Top requests/URLs
  varnishhist              # Response time histogram
  varnishncsa              # Apache/NCSA format log
  varnishadm               # Admin console

  # Key metrics from varnishstat:
  cache_hit / cache_miss   # Hit ratio (aim >90%)
  client_req               # Total requests
  backend_conn             # Backend connections
  n_object                 # Cached objects
  SMA.s0.g_bytes           # Memory used
  threads                  # Worker threads

PURGE & BAN:
  # Purge single URL
  sub vcl_recv {
      if (req.method == "PURGE") {
          if (!client.ip ~ purge_acl) { return (synth(403, "Not allowed")); }
          return (purge);
      }
  }
  # curl -X PURGE http://localhost/page.html

  # Ban pattern (regex purge)
  sub vcl_recv {
      if (req.method == "BAN") {
          ban("req.url ~ " + req.url);
          return (synth(200, "Banned"));
      }
  }
  # curl -X BAN http://localhost/images/.*

  # CLI ban
  varnishadm ban req.url "~" "/api/.*"
  varnishadm ban obj.http.content-type "~" "text/html"

  # Soft purge (serve stale while refetching)
  sub vcl_recv {
      if (req.method == "PURGE") {
          return (purge);
      }
  }
  sub vcl_hit {
      if (req.method == "PURGE") {
          set obj.ttl = 0s;
          set obj.grace = 10s;
          return (deliver);
      }
  }

ESI (Edge Side Includes):
  # Include dynamic fragments in cached pages
  sub vcl_backend_response {
      set beresp.do_esi = true;
  }

  # HTML:
  # <esi:include src="/user/sidebar"/>
  # <esi:include src="/ads/banner" onerror="continue"/>

  # Cached page (1h TTL) includes:
  #   - /user/sidebar (30s TTL, personalized)
  #   - /ads/banner (5m TTL)
  # Each fragment cached independently

WORDPRESS + VARNISH:
  sub vcl_recv {
      if (req.url ~ "wp-admin|wp-login|wp-cron") { return (pass); }
      if (req.http.Cookie ~ "wordpress_logged_in") { return (pass); }
      if (req.url ~ "/feed") { return (pass); }
      unset req.http.Cookie;
      return (hash);
  }
  sub vcl_backend_response {
      if (bereq.url !~ "wp-admin|wp-login") {
          unset beresp.http.Set-Cookie;
          set beresp.ttl = 1h;
      }
  }

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Varnish - HTTP Accelerator & Caching Proxy Reference

Commands:
  intro       Architecture, vs Nginx/CDN
  vcl         VCL config, caching rules, backends
  operations  CLI tools, purge/ban, ESI, WordPress

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  vcl)        cmd_vcl ;;
  operations) cmd_operations ;;
  help|*)     show_help ;;
esac
