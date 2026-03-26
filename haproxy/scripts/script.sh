#!/usr/bin/env bash
# haproxy — HAProxy load balancer reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
haproxy v1.0.0 — Load Balancer Reference

Usage: haproxy <command>

Commands:
  intro       HAProxy overview, L4/L7
  config      Config structure: global/defaults/frontend/backend
  frontend    Binds, ACLs, routing
  backend     Servers, health checks, balancing
  health      Health check options
  ssl         SSL termination, ciphers, HSTS
  stick-tables Rate limiting, tracking
  stats       Stats page, Prometheus

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# HAProxy — High Availability Proxy

## What is HAProxy?
HAProxy is a free, fast, and reliable load balancer and proxy server
for TCP and HTTP-based applications. It handles millions of concurrent
connections and is used by GitHub, Reddit, Stack Overflow, and Twitter.

## Key Capabilities
- Layer 4 (TCP) and Layer 7 (HTTP) load balancing
- SSL/TLS termination and re-encryption
- HTTP/2 and HTTP/3 (QUIC) support
- Content-based routing (ACLs)
- Health checking with multiple strategies
- Stick tables for session persistence and rate limiting
- Stats dashboard with CSV/JSON/Prometheus output
- Hot reload without dropping connections

## Architecture
```
Clients → Frontend (bind :80/:443)
              │
         ACL routing
              │
    ┌─────────┼──────────┐
    ▼         ▼          ▼
 Backend   Backend    Backend
 (web)     (api)      (static)
  ├─srv1    ├─srv1     ├─srv1
  ├─srv2    ├─srv2     └─srv2
  └─srv3    └─srv3
```

## Install
```bash
# RHEL/CentOS
yum install haproxy

# Ubuntu/Debian
apt install haproxy

# Latest version (PPA)
add-apt-repository ppa:vbernat/haproxy-2.8
apt install haproxy=2.8.*

# Config
/etc/haproxy/haproxy.cfg

# Test config
haproxy -c -f /etc/haproxy/haproxy.cfg

# Reload (zero downtime)
systemctl reload haproxy
```
EOF
}

cmd_config() {
    cat << 'EOF'
# HAProxy Configuration Structure

## Four Main Sections
```
global          # Process-wide settings
defaults        # Default values for all sections
frontend        # Client-facing listeners
backend         # Server pools
listen          # Combined frontend + backend (shortcut)
```

## Complete Example
```
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon
    maxconn 100000
    tune.ssl.default-dh-param 2048

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000ms
    timeout client  50000ms
    timeout server  50000ms
    retries 3
    option redispatch
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 503 /etc/haproxy/errors/503.http

frontend http_front
    bind *:80
    bind *:443 ssl crt /etc/ssl/certs/site.pem
    http-request redirect scheme https unless { ssl_fc }
    default_backend web_servers

backend web_servers
    balance roundrobin
    option httpchk GET /health
    server web1 10.0.0.1:8080 check
    server web2 10.0.0.2:8080 check
    server web3 10.0.0.3:8080 check backup
```

## Timeouts Reference
| Timeout | Default | Recommended |
|---------|---------|-------------|
| connect | none | 5s |
| client | none | 30-60s |
| server | none | 30-60s |
| http-request | 5s | 10s |
| http-keep-alive | none | 5s |
| queue | 5s | 30s |
| tunnel | none | 1h (websockets) |
EOF
}

cmd_frontend() {
    cat << 'EOF'
# Frontend Configuration

## Bind Directives
```
frontend mysite
    # HTTP
    bind *:80
    
    # HTTPS with certificate
    bind *:443 ssl crt /etc/ssl/certs/mysite.pem
    
    # Specific IP
    bind 10.0.0.1:80
    
    # Multiple certs (SNI)
    bind *:443 ssl crt /etc/ssl/certs/ crt-list /etc/haproxy/crt-list.txt
```

## ACL (Access Control Lists)
```
frontend http_front
    bind *:80
    
    # Host-based routing
    acl is_api hdr(host) -i api.example.com
    acl is_static hdr(host) -i static.example.com
    acl is_admin hdr(host) -i admin.example.com
    
    # Path-based routing
    acl is_api_path path_beg /api/
    acl is_static_path path_beg /static/ /images/ /css/ /js/
    
    # Method-based
    acl is_post method POST
    acl is_options method OPTIONS
    
    # Source IP
    acl is_internal src 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
    acl is_blocked src 1.2.3.4
    
    # Header-based
    acl is_websocket hdr(Upgrade) -i WebSocket
    acl has_bearer hdr(Authorization) -m beg Bearer
    
    # Route to backends
    use_backend api_servers if is_api or is_api_path
    use_backend static_servers if is_static or is_static_path
    use_backend admin_servers if is_admin is_internal  # AND logic
    
    http-request deny if is_blocked
    default_backend web_servers
```

## HTTP Request Manipulation
```
    # Add/Set headers
    http-request set-header X-Forwarded-Proto https if { ssl_fc }
    http-request set-header X-Real-IP %[src]
    http-request add-header X-Request-ID %[uuid()]
    
    # Redirect
    http-request redirect scheme https unless { ssl_fc }
    http-request redirect location /maintenance.html if is_maintenance
    
    # Rate limiting (with stick-table)
    http-request deny deny_status 429 if { sc_http_req_rate(0) gt 100 }
```
EOF
}

cmd_backend() {
    cat << 'EOF'
# Backend Configuration

## Server Lines
```
backend web_servers
    # Basic
    server web1 10.0.0.1:8080 check
    
    # With weight (higher = more traffic)
    server web1 10.0.0.1:8080 check weight 3
    server web2 10.0.0.2:8080 check weight 1
    
    # Backup server (only when all primary down)
    server web3 10.0.0.3:8080 check backup
    
    # Maximum connections per server
    server web1 10.0.0.1:8080 check maxconn 500
    
    # Slow start (ramp up over 30s after recovery)
    server web1 10.0.0.1:8080 check slowstart 30s
    
    # Resolve DNS
    server web1 web1.internal:8080 check resolvers dns
```

## Balance Algorithms
```
backend web_servers
    # Round Robin (default) — equal distribution
    balance roundrobin
    
    # Least Connections — fewest active connections
    balance leastconn
    
    # Source IP hash — same client → same server
    balance source
    
    # URI hash — same URL → same server (caching)
    balance uri
    
    # Header hash
    balance hdr(X-User-ID)
    
    # Random
    balance random(2)  # Power-of-2 random choices
    
    # First available (fill servers sequentially)
    balance first
```

## Session Persistence (Sticky Sessions)
```
backend app_servers
    balance roundrobin
    
    # Cookie-based (HAProxy inserts cookie)
    cookie SERVERID insert indirect nocache
    server app1 10.0.0.1:8080 check cookie s1
    server app2 10.0.0.2:8080 check cookie s2
    
    # Stick table (IP-based)
    stick-table type ip size 200k expire 30m
    stick on src
```

## Connection Settings
```
backend api_servers
    # HTTP mode settings
    option httpchk GET /health
    option forwardfor       # Add X-Forwarded-For
    option http-server-close  # Close server-side keep-alive
    
    # Retry on connection failure
    retries 3
    option redispatch       # Redispatch to another server on failure
    
    # Compression
    compression algo gzip
    compression type text/html text/css application/json
```
EOF
}

cmd_health() {
    cat << 'EOF'
# Health Checks

## Basic TCP Check
```
server web1 10.0.0.1:8080 check
# Just verifies TCP connection succeeds
```

## HTTP Health Check
```
backend web_servers
    option httpchk GET /health HTTP/1.1\r\nHost:\ www.example.com
    
    server web1 10.0.0.1:8080 check
    server web2 10.0.0.2:8080 check
```

## Advanced HTTP Check (HAProxy 2.2+)
```
backend web_servers
    option httpchk
    http-check send meth GET uri /health ver HTTP/1.1 hdr Host www.example.com
    http-check expect status 200
    
    # Multiple expects
    http-check expect status 200-299
    http-check expect string "ok"
    http-check expect ! string "maintenance"
```

## Check Parameters
```
server web1 10.0.0.1:8080 check inter 3s fall 3 rise 2
```

| Param | Default | Meaning |
|-------|---------|---------|
| inter | 2s | Check interval |
| fall | 3 | Failures before marking down |
| rise | 2 | Successes before marking up |
| port | server port | Alternate check port |
| addr | server addr | Alternate check address |

## Agent Check
```
# External agent responds with weight/status
server web1 10.0.0.1:8080 check agent-check agent-port 8081 agent-inter 5s
```

Agent response format:
```
ready           # Mark as up
drain           # Stop sending new connections
maint           # Mark as maintenance
50%             # Set weight to 50%
maxconn:100     # Set maxconn to 100
```

## Observe Layer 7
```
backend web_servers
    option httpchk GET /health
    
    # Also monitor real traffic for errors
    server web1 10.0.0.1:8080 check observe layer7
    
    # Mark down if >50% of responses are 5xx
    default-server error-limit 50 on-error mark-down
```
EOF
}

cmd_ssl() {
    cat << 'EOF'
# SSL/TLS Configuration

## SSL Termination
```
frontend https_front
    bind *:443 ssl crt /etc/ssl/certs/site.pem alpn h2,http/1.1
    
    # Combined PEM file: cert + key + CA chain
    # cat cert.pem key.pem ca-chain.pem > site.pem
```

## SNI (Multiple Certificates)
```
frontend https_front
    bind *:443 ssl crt /etc/ssl/certs/
    # HAProxy auto-loads all .pem files from directory
    
    # Or explicit crt-list
    bind *:443 ssl crt-list /etc/haproxy/crt-list.txt
```

crt-list.txt:
```
/etc/ssl/certs/example.com.pem example.com
/etc/ssl/certs/api.example.com.pem api.example.com
/etc/ssl/certs/wildcard.pem *.example.com
```

## TLS Settings
```
global
    # Modern TLS only
    ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
    ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets
    
    # Cipher suites for TLS 1.2
    ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384
```

## HSTS (HTTP Strict Transport Security)
```
frontend https_front
    http-response set-header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
```

## SSL Re-encryption (Backend)
```
backend secure_servers
    server srv1 10.0.0.1:443 ssl verify required ca-file /etc/ssl/ca.pem
    server srv2 10.0.0.2:443 ssl verify none  # Skip verification
```

## Let's Encrypt Integration
```bash
# Certbot with HAProxy
certbot certonly --standalone -d example.com --http-01-port 8888

# HAProxy redirects ACME challenge
frontend http_front
    acl is_acme path_beg /.well-known/acme-challenge/
    use_backend acme_backend if is_acme

backend acme_backend
    server certbot 127.0.0.1:8888
```
EOF
}

cmd_stick_tables() {
    cat << 'EOF'
# Stick Tables — Rate Limiting & Tracking

## Rate Limiting by IP
```
frontend http_front
    bind *:80
    
    # Define stick table
    stick-table type ip size 100k expire 30s store http_req_rate(10s)
    
    # Track source IP
    http-request track-sc0 src
    
    # Deny if >100 requests in 10 seconds
    http-request deny deny_status 429 if { sc_http_req_rate(0) gt 100 }
    
    default_backend web_servers
```

## Connection Rate Limiting
```
frontend http_front
    stick-table type ip size 100k expire 30s store conn_rate(10s),conn_cur
    http-request track-sc0 src
    
    # Max 20 new connections per 10 seconds
    http-request deny if { sc_conn_rate(0) gt 20 }
    
    # Max 100 concurrent connections per IP
    http-request deny if { sc_conn_cur(0) gt 100 }
```

## Track Multiple Counters
```
frontend http_front
    # Table with multiple stores
    stick-table type ip size 200k expire 5m \
        store http_req_rate(10s),http_err_rate(10s),conn_rate(10s),bytes_out_rate(1s)
    
    http-request track-sc0 src
    
    # Rate limit requests
    http-request deny deny_status 429 if { sc_http_req_rate(0) gt 100 }
    
    # Block IPs with high error rate (possible scanner)
    http-request deny deny_status 403 if { sc_http_err_rate(0) gt 50 }
    
    # Bandwidth limiting
    http-request deny if { sc0_bytes_out_rate gt 10000000 }  # 10MB/s
```

## Counters Reference
| Counter | Tracks |
|---------|--------|
| conn_cnt | Total connections |
| conn_cur | Current connections |
| conn_rate(period) | Connection rate |
| http_req_cnt | Total HTTP requests |
| http_req_rate(period) | HTTP request rate |
| http_err_cnt | Total HTTP errors |
| http_err_rate(period) | HTTP error rate |
| bytes_in_cnt | Total bytes received |
| bytes_out_cnt | Total bytes sent |
| gpc0 | General purpose counter |

## View Stick Table Contents
```bash
# Via stats socket
echo "show table http_front" | socat stdio /run/haproxy/admin.sock

# Clear table
echo "clear table http_front" | socat stdio /run/haproxy/admin.sock
```
EOF
}

cmd_stats() {
    cat << 'EOF'
# Stats & Monitoring

## Enable Stats Page
```
listen stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 10s
    stats auth admin:secretpassword
    stats admin if TRUE    # Allow admin actions (drain/disable)
```

Access: `http://haproxy-ip:8404/stats`

## Prometheus Endpoint (HAProxy 2.0+)
```
frontend prometheus
    bind *:8405
    http-request use-service prometheus-exporter if { path /metrics }
    no log
```

Metrics include:
- haproxy_frontend_current_sessions
- haproxy_backend_active_servers
- haproxy_server_response_time_average_seconds
- haproxy_frontend_bytes_in/out_total
- haproxy_backend_http_responses_total

## CSV Stats
```bash
# Via URL
curl -s "http://admin:pass@haproxy:8404/stats;csv"

# Via stats socket
echo "show stat" | socat stdio /run/haproxy/admin.sock
```

## Runtime Management (Stats Socket)
```bash
# Check server status
echo "show servers state" | socat stdio /run/haproxy/admin.sock

# Disable server
echo "disable server web_servers/web1" | socat stdio /run/haproxy/admin.sock

# Enable server
echo "enable server web_servers/web1" | socat stdio /run/haproxy/admin.sock

# Set server weight
echo "set weight web_servers/web1 50%" | socat stdio /run/haproxy/admin.sock

# Drain server (stop new connections, finish existing)
echo "set server web_servers/web1 state drain" | socat stdio /run/haproxy/admin.sock

# Show info
echo "show info" | socat stdio /run/haproxy/admin.sock

# Show errors
echo "show errors" | socat stdio /run/haproxy/admin.sock
```

## Logging
```
global
    log /dev/log local0 info
    log /dev/log local1 notice

defaults
    log global
    option httplog      # Detailed HTTP logging
    option dontlognull  # Don't log health checks
```

Log format (httplog):
```
Mar 24 10:30:00 haproxy[1234]: 10.0.0.1:56789 [24/Mar/2026:10:30:00.001]
  http_front web_servers/web1 0/0/1/15/16 200 1234 - - ---- 150/100/50/10/0
  0/0 "GET /api/data HTTP/1.1"
```
EOF
}

case "${1:-help}" in
    intro)        cmd_intro ;;
    config)       cmd_config ;;
    frontend)     cmd_frontend ;;
    backend)      cmd_backend ;;
    health)       cmd_health ;;
    ssl)          cmd_ssl ;;
    stick-tables) cmd_stick_tables ;;
    stats)        cmd_stats ;;
    help|-h)      show_help ;;
    version|-v)   echo "haproxy v$VERSION" ;;
    *)            echo "Unknown: $1"; show_help ;;
esac
