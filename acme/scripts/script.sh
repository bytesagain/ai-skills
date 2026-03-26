#!/bin/bash
# ACME Protocol & Certificate Automation Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ACME PROTOCOL REFERENCE                        ║
║          Automated Certificate Management Environment       ║
╚══════════════════════════════════════════════════════════════╝

ACME (RFC 8555) automates SSL/TLS certificate issuance and renewal.
Let's Encrypt popularized it, but ACME is an open standard used by
multiple Certificate Authorities.

KEY CONCEPTS:
  Account       ACME client registers with CA using a key pair
  Order         Request for certificate covering specific identifiers
  Authorization Prove domain control (challenges)
  Challenge     HTTP-01, DNS-01, or TLS-ALPN-01 validation
  Finalize      Submit CSR after challenges pass
  Certificate   Download issued certificate chain

ACME FLOW:
  1. Client creates account (or uses existing)
  2. Client submits order for domain(s)
  3. CA returns authorization(s) with challenges
  4. Client completes challenge(s) to prove control
  5. CA verifies challenges
  6. Client finalizes order with CSR
  7. CA issues certificate
  8. Client downloads certificate + chain

MAJOR ACME CAs:
  Let's Encrypt    Free, 90-day certs, most popular
  ZeroSSL          Free tier + paid options
  Buypass          Free 180-day certs
  Google Trust     ACME for Google Cloud customers
  SSL.com          Commercial CA with ACME support

WHY ACME MATTERS:
  - Manual cert management doesn't scale
  - Human error causes outages (expired certs)
  - ACME enables zero-touch certificate lifecycle
  - 90-day certs reduce exposure window
  - Wildcard certs via DNS-01 challenge
EOF
}

cmd_challenges() {
cat << 'EOF'
ACME CHALLENGE TYPES
====================

1. HTTP-01 CHALLENGE
   The most common validation method.

   How it works:
   - CA gives you a token
   - You place token at: http://<domain>/.well-known/acme-challenge/<token>
   - CA makes HTTP request to verify

   Requirements:
   - Port 80 must be open and reachable
   - Web server must serve the challenge file
   - Cannot use for wildcard certificates

   Best for:
   - Standard web servers (nginx, Apache, Caddy)
   - Simple single-domain certs
   - Environments where port 80 is available

   Example (manual):
   # CA provides:  token = abc123, key-auth = abc123.thumbprint
   mkdir -p /var/www/html/.well-known/acme-challenge/
   echo "abc123.thumbprint" > /var/www/html/.well-known/acme-challenge/abc123

2. DNS-01 CHALLENGE
   Prove domain ownership via DNS TXT record.

   How it works:
   - CA gives you a digest value
   - You create TXT record: _acme-challenge.<domain> = <digest>
   - CA queries DNS to verify

   Requirements:
   - DNS API access (for automation)
   - DNS propagation time (30s-5min typically)
   - Works behind firewalls, NATs, CDNs

   Best for:
   - Wildcard certificates (*.example.com)
   - Internal/private servers not reachable from internet
   - Load-balanced environments
   - CDN-fronted domains

   Supported DNS providers (certbot plugins):
   - Cloudflare      certbot-dns-cloudflare
   - Route53         certbot-dns-route53
   - Google DNS      certbot-dns-google
   - DigitalOcean    certbot-dns-digitalocean
   - Namecheap       certbot-dns-namecheap (3rd party)

3. TLS-ALPN-01 CHALLENGE
   Validation over TLS on port 443.

   How it works:
   - Client configures TLS server with self-signed cert containing challenge
   - Uses ALPN protocol "acme-tls/1"
   - CA connects to port 443 and verifies

   Requirements:
   - Port 443 control
   - TLS server that supports ALPN
   - No other TLS termination in front

   Best for:
   - Environments where port 80 is blocked
   - Pure TLS setups
   - Caddy uses this natively

CHALLENGE COMPARISON:
  ┌─────────────┬──────────┬──────────┬──────────────┐
  │ Feature     │ HTTP-01  │ DNS-01   │ TLS-ALPN-01  │
  ├─────────────┼──────────┼──────────┼──────────────┤
  │ Port needed │ 80       │ None     │ 443          │
  │ Wildcards   │ No       │ Yes      │ No           │
  │ Behind NAT  │ No       │ Yes      │ No           │
  │ Automation  │ Easy     │ Medium   │ Medium       │
  │ Speed       │ Seconds  │ Minutes  │ Seconds      │
  │ Popularity  │ Highest  │ High     │ Low          │
  └─────────────┴──────────┴──────────┴──────────────┘
EOF
}

cmd_clients() {
cat << 'EOF'
ACME CLIENTS COMPARISON
========================

1. CERTBOT (EFF)
   The original Let's Encrypt client. Most widely deployed.

   Install:
     apt install certbot                    # Debian/Ubuntu
     dnf install certbot                    # RHEL/Fedora
     brew install certbot                   # macOS
     pip install certbot                    # Python

   Basic usage:
     certbot certonly --webroot -w /var/www/html -d example.com
     certbot certonly --standalone -d example.com
     certbot certonly --nginx -d example.com
     certbot certonly --dns-cloudflare -d "*.example.com"

   Auto-renewal:
     certbot renew                          # Renew all due certs
     certbot renew --dry-run                # Test renewal
     systemctl enable certbot.timer         # Auto-renew timer

   Cert locations:
     /etc/letsencrypt/live/<domain>/fullchain.pem
     /etc/letsencrypt/live/<domain>/privkey.pem
     /etc/letsencrypt/live/<domain>/chain.pem
     /etc/letsencrypt/live/<domain>/cert.pem

2. ACME.SH (Shell)
   Pure shell implementation, no root required.

   Install:
     curl https://get.acme.sh | sh
     acme.sh --register-account -m email@example.com

   Usage:
     acme.sh --issue -d example.com -w /var/www/html
     acme.sh --issue -d example.com --standalone
     acme.sh --issue -d "*.example.com" --dns dns_cf
     acme.sh --install-cert -d example.com \
       --key-file /etc/ssl/private/key.pem \
       --fullchain-file /etc/ssl/certs/fullchain.pem \
       --reloadcmd "systemctl reload nginx"

   Switch CA:
     acme.sh --set-default-ca --server letsencrypt
     acme.sh --set-default-ca --server zerossl
     acme.sh --set-default-ca --server buypass

3. LEGO (Go)
   Lightweight, single binary, 100+ DNS providers.

   Install:
     go install github.com/go-acme/lego/v4/cmd/lego@latest

   Usage:
     lego --email=you@example.com --domains=example.com --http run
     lego --email=you@example.com --domains="*.example.com" --dns cloudflare run
     lego renew --days 30

4. CADDY (Built-in)
   Caddy has automatic HTTPS built in — zero config.

   Caddyfile:
     example.com {
       reverse_proxy localhost:8080
     }
   # That's it. Caddy handles ACME automatically.

CLIENT COMPARISON:
  ┌──────────┬────────────┬────────┬───────────┬──────────┐
  │ Client   │ Language   │ Root?  │ DNS Prov. │ Best For │
  ├──────────┼────────────┼────────┼───────────┼──────────┤
  │ certbot  │ Python     │ Yes    │ 20+       │ Standard │
  │ acme.sh  │ Shell      │ No     │ 150+      │ Minimal  │
  │ lego     │ Go         │ No     │ 100+      │ CI/CD    │
  │ Caddy    │ Go         │ Yes    │ Built-in  │ Reverse  │
  │ win-acme │ .NET       │ Yes    │ 20+       │ Windows  │
  │ Traefik  │ Go         │ Yes    │ Built-in  │ Docker   │
  └──────────┴────────────┴────────┴───────────┴──────────┘
EOF
}

cmd_workflow() {
cat << 'EOF'
CERTIFICATE LIFECYCLE MANAGEMENT
==================================

INITIAL SETUP WORKFLOW:

  1. Choose CA and client
     ┌─────────────┐
     │ Pick CA:    │ Let's Encrypt (free, 90-day)
     │ Pick client:│ certbot / acme.sh / lego
     └─────────────┘

  2. Validate domain ownership
     ┌─────────────────────────────────────────┐
     │ HTTP-01: Port 80 open? → certbot        │
     │ DNS-01:  API access? → wildcard support  │
     │ TLS-ALPN: Port 443 only? → Caddy        │
     └─────────────────────────────────────────┘

  3. Issue certificate
     certbot certonly -d example.com -d www.example.com

  4. Install certificate
     # nginx
     ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
     ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

  5. Configure auto-renewal
     # crontab
     0 3 * * * certbot renew --quiet --deploy-hook "systemctl reload nginx"

RENEWAL STRATEGY:
  Let's Encrypt certs expire in 90 days.
  Renew at 60 days (30-day buffer).

  Timeline:
    Day 0    ─── Certificate issued
    Day 30   ─── Still valid, no action
    Day 60   ─── Renewal window opens ← renew here
    Day 89   ─── Emergency renewal
    Day 90   ─── EXPIRED — site down

MULTI-DOMAIN STRATEGIES:

  SAN Certificate (Subject Alternative Names):
    certbot certonly -d example.com -d www.example.com -d api.example.com
    # Single cert covers multiple domains
    # Pro: Simple, one cert to manage
    # Con: All domains must be validated together

  Wildcard Certificate:
    certbot certonly --dns-cloudflare -d "*.example.com" -d example.com
    # Covers all subdomains
    # Pro: One cert for unlimited subdomains
    # Con: Requires DNS-01, wider blast radius

  Per-Domain Certificates:
    # Separate cert per domain/service
    # Pro: Independent lifecycle, least privilege
    # Con: More certs to manage

MONITORING:
  Check cert expiry:
    echo | openssl s_client -connect example.com:443 2>/dev/null | \
      openssl x509 -noout -enddate

  Parse expiry for alerting:
    expiry=$(echo | openssl s_client -connect example.com:443 2>/dev/null | \
      openssl x509 -noout -enddate | cut -d= -f2)
    expiry_epoch=$(date -d "$expiry" +%s)
    now_epoch=$(date +%s)
    days_left=$(( (expiry_epoch - now_epoch) / 86400 ))
    echo "Days until expiry: $days_left"
EOF
}

cmd_security() {
cat << 'EOF'
ACME SECURITY CONSIDERATIONS
==============================

1. ACCOUNT KEY PROTECTION
   Your ACME account key proves identity to the CA.

   Storage locations:
     certbot:  /etc/letsencrypt/accounts/
     acme.sh:  ~/.acme.sh/ca/
     lego:     ~/.lego/accounts/

   Best practices:
   - Restrict file permissions (600/700)
   - Back up encrypted
   - Rotate periodically (but not too often)
   - Never commit to version control

2. PRIVATE KEY SECURITY
   The certificate's private key is the crown jewel.

   chmod 600 /etc/letsencrypt/live/*/privkey.pem
   chown root:root /etc/letsencrypt/live/*/privkey.pem

   Key types:
     RSA 2048    Standard, wide compatibility
     RSA 4096    Higher security, slower handshake
     ECDSA P-256 Modern, fast, recommended
     ECDSA P-384 Higher security ECDSA

   Generate ECDSA key:
     certbot certonly --key-type ecdsa --elliptic-curve secp256r1 -d example.com

3. RATE LIMITS (Let's Encrypt)
   Certificates per Registered Domain:   50/week
   Duplicate Certificate:                 5/week
   Failed Validation:                    5/hour
   New Registrations:                    10/3 hours
   Pending Authorizations:               300/account

   Avoid hitting limits:
   - Use staging for testing: --server https://acme-staging-v02.api.letsencrypt.org/directory
   - Combine domains in SAN certs
   - Don't revoke+reissue unnecessarily

4. CAA RECORDS
   DNS CAA records restrict which CAs can issue for your domain.

   example.com. CAA 0 issue "letsencrypt.org"
   example.com. CAA 0 issuewild "letsencrypt.org"
   example.com. CAA 0 iodef "mailto:security@example.com"

   Check CAA:
     dig example.com CAA +short

5. CERTIFICATE TRANSPARENCY (CT)
   All public certs are logged in CT logs.

   Monitor your domains:
     https://crt.sh/?q=example.com
     https://transparencyreport.google.com/https/certificates

   Why it matters:
   - Detect unauthorized cert issuance
   - Catch phishing domains with similar names
   - Audit your CA usage

6. REVOCATION
   When to revoke:
   - Private key compromised
   - Domain sold/transferred
   - Certificate misissued

   How to revoke:
     certbot revoke --cert-path /etc/letsencrypt/live/example.com/cert.pem
     certbot revoke --cert-name example.com --reason keycompromise
EOF
}

cmd_automation() {
cat << 'EOF'
ACME AUTOMATION PATTERNS
==========================

1. NGINX + CERTBOT

   Initial setup:
     certbot --nginx -d example.com -d www.example.com

   Auto-generated nginx config:
     server {
       listen 443 ssl;
       server_name example.com;
       ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
       include /etc/letsencrypt/options-ssl-nginx.conf;
       ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
     }

   Renewal hook:
     certbot renew --deploy-hook "nginx -s reload"

2. DOCKER + TRAEFIK

   docker-compose.yml:
     traefik:
       image: traefik:v2
       command:
         - --certificatesresolvers.le.acme.email=you@example.com
         - --certificatesresolvers.le.acme.storage=/acme/acme.json
         - --certificatesresolvers.le.acme.httpchallenge.entrypoint=web
       ports:
         - "80:80"
         - "443:443"
       volumes:
         - ./acme:/acme
         - /var/run/docker.sock:/var/run/docker.sock

     webapp:
       image: myapp
       labels:
         - traefik.http.routers.app.rule=Host(`example.com`)
         - traefik.http.routers.app.tls.certresolver=le

3. KUBERNETES + CERT-MANAGER

   Install cert-manager:
     kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.yaml

   ClusterIssuer:
     apiVersion: cert-manager.io/v1
     kind: ClusterIssuer
     metadata:
       name: letsencrypt-prod
     spec:
       acme:
         server: https://acme-v02.api.letsencrypt.org/directory
         email: you@example.com
         privateKeySecretRef:
           name: letsencrypt-prod
         solvers:
         - http01:
             ingress:
               class: nginx

   Certificate request:
     apiVersion: cert-manager.io/v1
     kind: Certificate
     metadata:
       name: example-com
     spec:
       secretName: example-com-tls
       issuerRef:
         name: letsencrypt-prod
         kind: ClusterIssuer
       dnsNames:
       - example.com
       - www.example.com

4. CI/CD PIPELINE

   GitHub Actions example:
     - name: Issue cert
       run: |
         sudo certbot certonly --standalone -d staging.example.com \
           --agree-tos -m ci@example.com --non-interactive
         # Deploy cert to cloud provider
         aws acm import-certificate \
           --certificate fileb:///etc/letsencrypt/live/staging.example.com/cert.pem \
           --private-key fileb:///etc/letsencrypt/live/staging.example.com/privkey.pem \
           --certificate-chain fileb:///etc/letsencrypt/live/staging.example.com/chain.pem
EOF
}

cmd_troubleshoot() {
cat << 'EOF'
ACME TROUBLESHOOTING GUIDE
============================

COMMON ERRORS:

1. "Challenge failed for domain"
   Causes:
   - Port 80 blocked by firewall
   - Wrong web root path
   - DNS not pointing to this server
   - CDN/proxy intercepting challenge

   Debug:
     # Check port 80
     curl -I http://example.com/.well-known/acme-challenge/test
     # Check DNS
     dig +short example.com A
     # Check firewall
     iptables -L -n | grep 80
     ss -tlnp | grep :80

2. "Too many certificates already issued"
   You hit the rate limit (50/week per registered domain).

   Solutions:
   - Wait a week
   - Use staging server for testing
   - Combine domains into one SAN cert
   - Check if duplicate certs were issued: https://crt.sh

3. "DNS problem: NXDOMAIN"
   DNS-01 challenge can't find TXT record.

   Debug:
     dig _acme-challenge.example.com TXT +short
     # Check propagation
     dig @8.8.8.8 _acme-challenge.example.com TXT
     dig @1.1.1.1 _acme-challenge.example.com TXT

   Common causes:
   - DNS propagation delay (wait 2-5 minutes)
   - Wrong DNS provider API credentials
   - TXT record set on wrong domain level
   - CNAME chain breaking TXT lookup

4. "Unauthorized: account not registered"
   ACME account needs registration.

   Fix:
     certbot register --agree-tos -m you@example.com
     acme.sh --register-account -m you@example.com

5. "Connection refused" or "Timeout"
   CA can't reach your server.

   Checklist:
   ☐ DNS resolves to correct IP
   ☐ Port 80 (HTTP-01) or 443 (TLS-ALPN) is open
   ☐ No firewall blocking Let's Encrypt IPs
   ☐ No GeoIP blocking (LE validates from multiple locations)
   ☐ Server is actually running

6. Certificate chain issues
   Browser shows "NET::ERR_CERT_AUTHORITY_INVALID"

   Fix: Use fullchain.pem (cert + intermediate), not just cert.pem

   Verify chain:
     openssl s_client -connect example.com:443 -showcerts
     # Should show 2-3 certificates in chain

   Test with SSL Labs:
     https://www.ssllabs.com/ssltest/analyze.html?d=example.com

DIAGNOSTIC COMMANDS:
  # View certificate details
  openssl x509 -in cert.pem -noout -text

  # Check cert matches key
  openssl x509 -noout -modulus -in cert.pem | md5sum
  openssl rsa -noout -modulus -in key.pem | md5sum
  # Both should match

  # Test TLS connection
  openssl s_client -connect example.com:443 -servername example.com

  # Check OCSP stapling
  openssl s_client -connect example.com:443 -status < /dev/null 2>&1 | grep "OCSP"
EOF
}

cmd_best_practices() {
cat << 'EOF'
ACME BEST PRACTICES
=====================

1. ALWAYS USE AUTO-RENEWAL
   Never rely on manual renewal. Set up:
   - certbot: systemd timer (certbot.timer) or cron
   - acme.sh: auto-installs cron job
   - Caddy/Traefik: built-in auto-renewal

   Test renewal works:
     certbot renew --dry-run

2. USE DEPLOY HOOKS
   Reload services after renewal:
     certbot renew --deploy-hook "systemctl reload nginx"
     certbot renew --deploy-hook "/usr/local/bin/deploy-cert.sh"

   Common hooks:
   - nginx:   nginx -s reload
   - Apache:  systemctl reload apache2
   - HAProxy: cat fullchain.pem privkey.pem > combined.pem && systemctl reload haproxy
   - Postfix: systemctl reload postfix
   - Custom:  Notify monitoring, update CDN, sync to other servers

3. SEPARATE STAGING AND PRODUCTION
   Always test with staging first:
     certbot certonly --staging -d example.com
   Staging has much higher rate limits.

4. MONITOR CERTIFICATE EXPIRY
   Don't trust auto-renewal blindly.

   Monitoring tools:
   - Prometheus + blackbox_exporter
   - Nagios/Icinga check_http --ssl
   - UptimeRobot SSL monitoring
   - Simple cron script:

     #!/bin/bash
     for domain in example.com api.example.com; do
       expiry=$(echo | openssl s_client -connect $domain:443 2>/dev/null | \
         openssl x509 -noout -enddate | cut -d= -f2)
       days=$(( ($(date -d "$expiry" +%s) - $(date +%s)) / 86400 ))
       if [ $days -lt 14 ]; then
         echo "WARNING: $domain expires in $days days" | mail -s "Cert Alert" admin@example.com
       fi
     done

5. USE ECDSA KEYS
   Faster handshakes, smaller certs, same security:
     certbot certonly --key-type ecdsa -d example.com

6. IMPLEMENT HSTS
   After ACME is working reliably:
     # nginx
     add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

   Start with short max-age, increase gradually.

7. BACKUP STRATEGY
   Back up:
   - /etc/letsencrypt/ (certbot)
   - ~/.acme.sh/ (acme.sh)
   - Account keys and cert private keys

   Don't back up:
   - Public certificates (they're in CT logs anyway)
   - Expired certificates

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
ACME Protocol & Certificate Automation Reference

Commands:
  intro           ACME protocol overview and key concepts
  challenges      HTTP-01, DNS-01, TLS-ALPN-01 challenge types
  clients         Certbot, acme.sh, lego, Caddy comparison
  workflow        Certificate lifecycle and renewal strategies
  security        Key protection, rate limits, CAA, CT logs
  automation      Nginx, Docker/Traefik, Kubernetes/cert-manager patterns
  troubleshoot    Common errors and diagnostic commands
  best-practices  Production deployment recommendations

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)           cmd_intro ;;
  challenges)      cmd_challenges ;;
  clients)         cmd_clients ;;
  workflow)        cmd_workflow ;;
  security)        cmd_security ;;
  automation)      cmd_automation ;;
  troubleshoot)    cmd_troubleshoot ;;
  best-practices)  cmd_best_practices ;;
  help|*)          show_help ;;
esac
