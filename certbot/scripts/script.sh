#!/bin/bash
# Certbot - Let's Encrypt ACME Client Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CERTBOT REFERENCE                              ║
║          Free TLS Certificates from Let's Encrypt           ║
╚══════════════════════════════════════════════════════════════╝

Certbot is the official ACME client for obtaining free TLS/SSL
certificates from Let's Encrypt. It automates certificate issuance,
installation, and renewal.

KEY CONCEPTS:
  ACME           Automatic Certificate Management Environment protocol
  Let's Encrypt  Free, automated, open Certificate Authority (CA)
  Challenge      Prove you control the domain (HTTP-01, DNS-01, TLS-ALPN-01)
  Renewal        Certificates valid 90 days, auto-renew recommended
  Wildcard       *.example.com — requires DNS-01 challenge
  Rate limits    50 certs/domain/week, 5 duplicate/week

CHALLENGE TYPES:
  HTTP-01     Place file at /.well-known/acme-challenge/
              Needs port 80 open. Most common.
  DNS-01      Create TXT record _acme-challenge.example.com
              Required for wildcards. Works without port 80.
  TLS-ALPN-01 Via port 443 TLS negotiation. Rare.

CERTIFICATE FILES:
  /etc/letsencrypt/live/example.com/
  ├── cert.pem        Your domain certificate
  ├── chain.pem       Intermediate CA certificate
  ├── fullchain.pem   cert.pem + chain.pem (use this for servers)
  └── privkey.pem     Private key (keep secret!)

INSTALL:
  # Recommended: snap
  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot

  # Or pip
  pip install certbot

  # Or package manager
  sudo apt install certbot              # Debian/Ubuntu
  sudo yum install certbot              # RHEL/CentOS
  brew install certbot                  # macOS
EOF
}

cmd_obtain() {
cat << 'EOF'
OBTAINING CERTIFICATES
========================

NGINX (automatic install):
  sudo certbot --nginx -d example.com -d www.example.com
  # Certbot modifies nginx config, installs cert, sets up redirect

APACHE (automatic install):
  sudo certbot --apache -d example.com -d www.example.com
  # Certbot modifies Apache config automatically

STANDALONE (no web server running):
  sudo certbot certonly --standalone -d example.com
  # Certbot spins up its own temporary web server on port 80
  # Port 80 must be free!

WEBROOT (web server already running):
  sudo certbot certonly --webroot -w /var/www/html -d example.com
  # Places challenge file in your web root
  # Web server must serve /.well-known/acme-challenge/

MANUAL (interactive):
  sudo certbot certonly --manual -d example.com
  # Shows you what file to create or DNS record to add
  # Good for one-off certs on remote servers

DNS CHALLENGE (for wildcards):
  sudo certbot certonly --manual --preferred-challenges dns \
    -d "*.example.com" -d example.com
  # Prompts you to create TXT record manually

  # Automated DNS with plugin:
  sudo certbot certonly --dns-cloudflare \
    --dns-cloudflare-credentials ~/.secrets/cloudflare.ini \
    -d "*.example.com" -d example.com

MULTIPLE DOMAINS:
  sudo certbot --nginx \
    -d example.com \
    -d www.example.com \
    -d api.example.com \
    -d blog.example.com

NON-INTERACTIVE:
  sudo certbot certonly --nginx \
    -d example.com \
    --non-interactive \
    --agree-tos \
    --email admin@example.com \
    --no-eff-email

STAGING (testing without rate limits):
  sudo certbot certonly --nginx -d example.com --staging
  # Issues a fake cert from staging CA
  # Always test with --staging first!
EOF
}

cmd_renewal() {
cat << 'EOF'
RENEWAL & MANAGEMENT
======================

AUTO-RENEWAL:
  Certbot installs a systemd timer or cron automatically.

  # Check timer
  systemctl list-timers | grep certbot

  # Manual renewal test (dry run)
  sudo certbot renew --dry-run

  # Force renewal
  sudo certbot renew --force-renewal

  # Renew specific cert
  sudo certbot certonly --force-renewal -d example.com

RENEWAL HOOKS:
  Run commands before/after renewal.

  sudo certbot renew \
    --pre-hook "systemctl stop nginx" \
    --post-hook "systemctl start nginx"

  # Or deploy hook (runs only on successful renewal)
  sudo certbot renew \
    --deploy-hook "systemctl reload nginx"

  # Permanent hooks (in renewal config):
  # /etc/letsencrypt/renewal/example.com.conf
  [renewalparams]
  pre_hook = systemctl stop nginx
  post_hook = systemctl start nginx
  deploy_hook = /usr/local/bin/deploy-cert.sh

LIST CERTIFICATES:
  sudo certbot certificates
  # Shows all managed certs, expiry dates, domains

DELETE CERTIFICATE:
  sudo certbot delete --cert-name example.com

REVOKE CERTIFICATE:
  sudo certbot revoke --cert-path /etc/letsencrypt/live/example.com/cert.pem
  # Reasons: unspecified, keycompromise, affiliationchanged, superseded

EXPAND (add domains):
  sudo certbot certonly --expand -d example.com -d www.example.com -d new.example.com

CHANGE EMAIL:
  sudo certbot update_account --email new@example.com

RENEWAL CONFIG:
  /etc/letsencrypt/renewal/example.com.conf
  Contains all options used during original issuance.
  Certbot replays these on renewal.
EOF
}

cmd_webservers() {
cat << 'EOF'
WEB SERVER CONFIGURATION
===========================

NGINX MANUAL CONFIG:
  server {
      listen 80;
      server_name example.com www.example.com;
      return 301 https://$host$request_uri;
  }

  server {
      listen 443 ssl http2;
      server_name example.com www.example.com;

      ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

      # Recommended SSL settings
      ssl_protocols TLSv1.2 TLSv1.3;
      ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384;
      ssl_prefer_server_ciphers off;
      ssl_session_timeout 1d;
      ssl_session_cache shared:SSL:10m;
      ssl_session_tickets off;

      # HSTS
      add_header Strict-Transport-Security "max-age=63072000" always;

      # OCSP Stapling
      ssl_stapling on;
      ssl_stapling_verify on;
      ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
  }

APACHE MANUAL CONFIG:
  <VirtualHost *:443>
      ServerName example.com
      SSLEngine on
      SSLCertificateFile /etc/letsencrypt/live/example.com/fullchain.pem
      SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem

      # Modern TLS
      SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1
      Header always set Strict-Transport-Security "max-age=63072000"
  </VirtualHost>

  <VirtualHost *:80>
      ServerName example.com
      Redirect permanent / https://example.com/
  </VirtualHost>

HAPROXY:
  frontend https
      bind *:443 ssl crt /etc/haproxy/certs/example.com.pem
      # Combine: cat fullchain.pem privkey.pem > example.com.pem

DOCKER + NGINX:
  # docker-compose.yml
  services:
    certbot:
      image: certbot/certbot
      volumes:
        - ./certbot/conf:/etc/letsencrypt
        - ./certbot/www:/var/www/certbot
      command: certonly --webroot -w /var/www/certbot -d example.com

    nginx:
      image: nginx
      ports: ["80:80", "443:443"]
      volumes:
        - ./certbot/conf:/etc/letsencrypt:ro
        - ./certbot/www:/var/www/certbot:ro

RATE LIMITS:
  Certificates per domain:    50/week
  Duplicate certificates:      5/week
  Failed validations:          5/hour/account/hostname
  New registrations:           10/3 hours/IP
  Orders per account:         300/3 hours
  SANs per certificate:       100

  Staging has much higher limits — always test there first!

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Certbot - Let's Encrypt ACME Client Reference

Commands:
  intro        Overview, challenges, installation
  obtain       Get certificates (nginx/apache/standalone/DNS)
  renewal      Auto-renew, hooks, manage certs
  webservers   Nginx/Apache/HAProxy/Docker config

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  obtain)     cmd_obtain ;;
  renewal)    cmd_renewal ;;
  webservers) cmd_webservers ;;
  help|*)     show_help ;;
esac
