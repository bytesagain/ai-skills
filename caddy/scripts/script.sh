#!/bin/bash
# Caddy - Automatic HTTPS Web Server Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CADDY REFERENCE                                ║
║          The Ultimate Easy Web Server                       ║
╚══════════════════════════════════════════════════════════════╝

Caddy is a powerful, enterprise-ready web server with automatic HTTPS.
It obtains and renews TLS certificates automatically — zero configuration.

KEY FEATURES:
  Auto HTTPS     Automatic certificate from Let's Encrypt / ZeroSSL
  HTTP/3         QUIC support built-in
  Reverse proxy  Production-ready load balancer
  File server    Static file serving with directory listings
  Caddyfile      Simple, human-readable configuration
  JSON config    Full API-driven configuration
  Plugins        Extensible architecture (DNS providers, auth, etc.)

CADDY vs NGINX vs APACHE:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Caddy    │ Nginx    │ Apache   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Auto HTTPS   │ Built-in │ Manual   │ Manual   │
  │ Config       │ Simple   │ Complex  │ Complex  │
  │ HTTP/3       │ Built-in │ Patch    │ No       │
  │ API config   │ Built-in │ No*      │ No       │
  │ Memory       │ ~20MB    │ ~5MB     │ ~30MB    │
  │ Performance  │ Great    │ Best     │ Good     │
  │ Learning     │ Minutes  │ Hours    │ Hours    │
  │ Language     │ Go       │ C        │ C        │
  └──────────────┴──────────┴──────────┴──────────┘
EOF
}

cmd_caddyfile() {
cat << 'EOF'
CADDYFILE CONFIGURATION
==========================

STATIC FILE SERVER:
  # Serve current directory
  :8080 {
      file_server
  }

  # With directory listing
  :8080 {
      file_server browse
      root * /var/www/html
  }

REVERSE PROXY:
  example.com {
      reverse_proxy localhost:8080
  }

  # That's it! Caddy auto-obtains HTTPS certificate.

MULTIPLE SITES:
  example.com {
      reverse_proxy localhost:3000
  }

  api.example.com {
      reverse_proxy localhost:8080
  }

  blog.example.com {
      root * /var/www/blog
      file_server
  }

LOAD BALANCING:
  example.com {
      reverse_proxy localhost:8001 localhost:8002 localhost:8003 {
          lb_policy round_robin        # or random, least_conn, ip_hash
          health_uri /health
          health_interval 30s
          health_timeout 5s
      }
  }

PATH ROUTING:
  example.com {
      handle /api/* {
          reverse_proxy localhost:8080
      }
      handle /ws/* {
          reverse_proxy localhost:8081
      }
      handle {
          root * /var/www/frontend
          file_server
          try_files {path} /index.html  # SPA fallback
      }
  }

HEADERS & SECURITY:
  example.com {
      header {
          X-Frame-Options DENY
          X-Content-Type-Options nosniff
          Referrer-Policy strict-origin-when-cross-origin
          Content-Security-Policy "default-src 'self'"
          -Server                          # Remove Server header
      }
      reverse_proxy localhost:3000
  }

GZIP COMPRESSION:
  example.com {
      encode gzip zstd
      file_server
  }

REDIRECTS:
  www.example.com {
      redir https://example.com{uri} permanent
  }

  example.com {
      redir /old-page /new-page permanent
      redir /docs/* /documentation/{http.request.uri.path.1} 302
  }

BASIC AUTH:
  example.com {
      basicauth /admin/* {
          admin $2a$14$...   # bcrypt hash
      }
      reverse_proxy localhost:3000
  }

  # Generate hash:
  caddy hash-password --plaintext 'mypassword'

LOGGING:
  example.com {
      log {
          output file /var/log/caddy/access.log {
              roll_size 100mb
              roll_keep 5
          }
          format json
      }
  }
EOF
}

cmd_https() {
cat << 'EOF'
AUTOMATIC HTTPS
=================

HOW IT WORKS:
  1. You specify a domain name in Caddyfile
  2. Caddy obtains certificate from Let's Encrypt (or ZeroSSL)
  3. Caddy auto-renews before expiry
  4. Caddy redirects HTTP → HTTPS automatically
  5. Caddy enables OCSP stapling automatically
  6. Caddy uses modern TLS defaults (TLS 1.2+)

  Zero configuration needed.

CERTIFICATE AUTHORITIES:
  Default: Let's Encrypt (with ZeroSSL fallback)

  # Use specific CA
  example.com {
      tls {
          issuer acme {
              ca https://acme-v02.api.letsencrypt.org/directory
          }
      }
  }

  # Internal CA (self-signed, for dev/internal)
  localhost {
      tls internal
  }

  # Custom certificate
  example.com {
      tls /path/to/cert.pem /path/to/key.pem
  }

WILDCARD CERTIFICATES:
  *.example.com {
      tls {
          dns cloudflare {env.CF_API_TOKEN}
      }
      reverse_proxy localhost:3000
  }

  # Requires DNS challenge (install DNS plugin)
  # xcaddy build --with github.com/caddy-dns/cloudflare

ON-DEMAND TLS:
  For unknown domains (SaaS, multi-tenant):

  {
      on_demand_tls {
          ask http://localhost:5555/check  # Your validation endpoint
          interval 5m
          burst 10
      }
  }

  :443 {
      tls {
          on_demand
      }
      reverse_proxy localhost:3000
  }

LOCAL HTTPS (Development):
  localhost {
      respond "Hello, HTTPS!"
  }
  # Caddy generates a local CA and self-signed cert
  # Trust it: caddy trust

ACME CHALLENGE TYPES:
  HTTP-01:    Default, needs port 80
  TLS-ALPN:   Via port 443 (automatic fallback)
  DNS-01:     For wildcards, needs DNS plugin
EOF
}

cmd_deploy() {
cat << 'EOF'
DEPLOYMENT
============

INSTALL:
  # Debian/Ubuntu
  sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/caddy-stable.list
  sudo apt update && sudo apt install caddy

  # Docker
  docker run -d -p 80:80 -p 443:443 \
    -v caddy_data:/data -v caddy_config:/config \
    -v $PWD/Caddyfile:/etc/caddy/Caddyfile \
    caddy

  # Binary
  curl -o caddy "https://caddyserver.com/api/download?os=linux&arch=amd64"

CLI COMMANDS:
  caddy start                     # Start in background
  caddy stop                      # Stop
  caddy reload                    # Reload config (zero downtime)
  caddy run                       # Run in foreground
  caddy adapt                     # Convert Caddyfile to JSON
  caddy validate                  # Validate config
  caddy fmt                       # Format Caddyfile
  caddy trust                     # Trust local CA
  caddy reverse-proxy --from :80 --to :8080  # Quick reverse proxy

JSON API:
  # Load config via API
  curl localhost:2019/load \
    -H "Content-Type: application/json" \
    -d @caddy.json

  # Get current config
  curl localhost:2019/config/

  # Update specific path
  curl -X PATCH localhost:2019/config/apps/http/servers/srv0/routes \
    -H "Content-Type: application/json" \
    -d '[...]'

SYSTEMD:
  sudo systemctl enable caddy
  sudo systemctl start caddy
  sudo systemctl reload caddy      # Zero-downtime reload
  journalctl -u caddy -f           # View logs

CUSTOM BUILD (xcaddy):
  # Build with plugins
  xcaddy build --with github.com/caddy-dns/cloudflare
  xcaddy build --with github.com/caddyserver/transform-encoder

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Caddy - Automatic HTTPS Web Server Reference

Commands:
  intro       Overview, comparison with Nginx/Apache
  caddyfile   Configuration, proxying, routing, auth
  https       Automatic certs, wildcards, on-demand TLS
  deploy      Installation, CLI, API, systemd, plugins

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  caddyfile) cmd_caddyfile ;;
  https)     cmd_https ;;
  deploy)    cmd_deploy ;;
  help|*)    show_help ;;
esac
