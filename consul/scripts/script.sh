#!/usr/bin/env bash
# consul — HashiCorp Consul service mesh reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
consul v1.0.0 — Service Mesh & Discovery Reference

Usage: consul <command>

Commands:
  intro       Consul overview, service mesh concepts
  agent       Agent modes, configuration, data directory
  services    Service registration, DNS, HTTP API
  kv          Key/value store operations
  connect     Service mesh, sidecar proxies, intentions
  acl         ACL system, policies, tokens
  template    consul-template, dynamic config
  ops         Operations, snapshots, maintenance

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# HashiCorp Consul

## What is Consul?
Consul is a multi-cloud service networking platform that provides:
- **Service Discovery**: Register and find services via DNS or HTTP
- **Health Checking**: Automated health monitoring for services
- **Key/Value Store**: Distributed, consistent KV for config
- **Service Mesh**: Secure service-to-service communication with mTLS
- **Multi-Datacenter**: Built-in WAN federation

## Architecture
```
    Client Agents (on every node)
        │
        ▼ gossip (LAN)
    Server Agents (3-5 per datacenter)
        │ Raft consensus
        ▼
    Leader (one server)
        │
        ▼ gossip (WAN)
    Other Datacenters
```

## Components
- **Agent**: Runs on every node (client or server mode)
- **Server**: Participates in consensus, stores state
- **Client**: Forwards requests to servers, runs health checks
- **Catalog**: Registry of all services and nodes
- **Connect**: Service mesh with automatic mTLS

## Quick Start
```bash
# Dev mode (single node, in-memory)
consul agent -dev

# Check members
consul members

# Register a service
consul services register -name=web -port=8080

# Query via DNS
dig @127.0.0.1 -p 8600 web.service.consul

# Query via HTTP
curl http://localhost:8500/v1/catalog/service/web

# KV operations
consul kv put config/db/host 10.0.0.1
consul kv get config/db/host
```
EOF
}

cmd_agent() {
    cat << 'EOF'
# Consul Agent

## Server Mode
```bash
consul agent -server \
  -bootstrap-expect=3 \
  -data-dir=/var/lib/consul \
  -bind=10.0.0.1 \
  -client=0.0.0.0 \
  -ui \
  -node=consul-server-1

# Or via config file
consul agent -config-dir=/etc/consul.d/
```

Server config (`/etc/consul.d/server.hcl`):
```hcl
server           = true
bootstrap_expect = 3
datacenter       = "dc1"
data_dir         = "/var/lib/consul"
bind_addr        = "10.0.0.1"
client_addr      = "0.0.0.0"
ui_config {
  enabled = true
}
retry_join = ["10.0.0.2", "10.0.0.3"]
```

## Client Mode
```hcl
# /etc/consul.d/client.hcl
server     = false
datacenter = "dc1"
data_dir   = "/var/lib/consul"
bind_addr  = "{{ GetPrivateIP }}"
retry_join = ["10.0.0.1", "10.0.0.2", "10.0.0.3"]
```

## Server Count
| Servers | Fault Tolerance | Quorum |
|---------|----------------|--------|
| 1 | 0 (no HA) | 1 |
| 3 | 1 failure | 2 |
| 5 | 2 failures | 3 |
| 7 | 3 failures | 4 |

Recommended: 3 for small, 5 for production

## Ports
| Port | Protocol | Purpose |
|------|----------|---------|
| 8300 | TCP | Server RPC |
| 8301 | TCP/UDP | LAN gossip |
| 8302 | TCP/UDP | WAN gossip |
| 8500 | TCP | HTTP API |
| 8501 | TCP | HTTPS API |
| 8600 | TCP/UDP | DNS |
| 21000-21255 | TCP | Sidecar proxies |
EOF
}

cmd_services() {
    cat << 'EOF'
# Service Registration & Discovery

## Register via Config File
```hcl
# /etc/consul.d/web.hcl
service {
  name = "web"
  port = 8080
  tags = ["v1", "production"]
  
  meta {
    version = "1.2.0"
    environment = "production"
  }
  
  check {
    http     = "http://localhost:8080/health"
    interval = "10s"
    timeout  = "3s"
  }
}
```

## Register via HTTP API
```bash
curl -X PUT http://localhost:8500/v1/agent/service/register -d '{
  "Name": "api",
  "Port": 3000,
  "Tags": ["v2"],
  "Check": {
    "HTTP": "http://localhost:3000/health",
    "Interval": "10s"
  }
}'
```

## Register via CLI
```bash
consul services register -name=web -port=8080 -tag=v1
```

## DNS Discovery
```bash
# Find service
dig @127.0.0.1 -p 8600 web.service.consul

# Find service with tag
dig @127.0.0.1 -p 8600 v1.web.service.consul

# SRV record (includes port)
dig @127.0.0.1 -p 8600 web.service.consul SRV

# In another datacenter
dig @127.0.0.1 -p 8600 web.service.dc2.consul
```

## HTTP API Discovery
```bash
# List all services
curl http://localhost:8500/v1/catalog/services

# Get service instances
curl http://localhost:8500/v1/catalog/service/web

# Health-filtered (only passing)
curl http://localhost:8500/v1/health/service/web?passing=true
```

## Health Check Types
```hcl
# HTTP check
check {
  http     = "http://localhost:8080/health"
  interval = "10s"
}

# TCP check
check {
  tcp      = "localhost:5432"
  interval = "10s"
}

# Script check
check {
  args     = ["/usr/local/bin/check_pg.sh"]
  interval = "30s"
}

# TTL check (service reports its own status)
check {
  ttl = "30s"
}
# Then: curl -X PUT http://localhost:8500/v1/agent/check/pass/service:web
```
EOF
}

cmd_kv() {
    cat << 'EOF'
# Key/Value Store

## CLI Operations
```bash
# Put a value
consul kv put config/db/host 10.0.0.1
consul kv put config/db/port 5432

# Get a value
consul kv get config/db/host
# Output: 10.0.0.1

# Get with metadata
consul kv get -detailed config/db/host

# List keys by prefix
consul kv get -recurse config/
consul kv get -keys config/

# Delete
consul kv delete config/db/host
consul kv delete -recurse config/db/

# Export/Import (JSON)
consul kv export config/ > backup.json
consul kv import @backup.json
```

## HTTP API
```bash
# PUT
curl -X PUT -d 'myvalue' http://localhost:8500/v1/kv/config/key

# GET
curl http://localhost:8500/v1/kv/config/key
# Returns base64 encoded value

# GET decoded
curl -s http://localhost:8500/v1/kv/config/key | python3 -c "
import sys, json, base64
data = json.load(sys.stdin)
print(base64.b64decode(data[0]['Value']).decode())
"

# DELETE
curl -X DELETE http://localhost:8500/v1/kv/config/key

# List keys
curl http://localhost:8500/v1/kv/config/?keys

# CAS (Check-And-Set) — atomic update
curl -X PUT -d 'newvalue' http://localhost:8500/v1/kv/config/key?cas=42
```

## Distributed Locking
```bash
# Acquire lock (session-based)
SESSION=$(curl -X PUT -d '{"Name":"mylock","TTL":"30s"}' \
  http://localhost:8500/v1/session/create | python3 -c "import sys,json;print(json.load(sys.stdin)['ID'])")

# Try to acquire
curl -X PUT -d 'locked' "http://localhost:8500/v1/kv/locks/mylock?acquire=$SESSION"
# Returns: true (acquired) or false (already locked)

# Release
curl -X PUT "http://localhost:8500/v1/kv/locks/mylock?release=$SESSION"
```

## Watch for Changes
```bash
# Block until value changes (long poll)
consul watch -type=key -key=config/db/host -- /usr/local/bin/on-config-change.sh

# Watch prefix
consul watch -type=keyprefix -prefix=config/ -- /usr/local/bin/reload-config.sh
```
EOF
}

cmd_connect() {
    cat << 'EOF'
# Consul Connect (Service Mesh)

## What is Connect?
Connect provides service-to-service communication with:
- Automatic mTLS encryption
- Identity-based authorization (intentions)
- Sidecar proxy (Envoy) for traffic management

## Enable Connect
```hcl
# Server config
connect {
  enabled = true
}
```

## Service with Sidecar
```hcl
service {
  name = "web"
  port = 8080
  
  connect {
    sidecar_service {
      proxy {
        upstreams {
          destination_name = "api"
          local_bind_port  = 9191
        }
      }
    }
  }
}
```

Web service connects to `api` via localhost:9191 → sidecar encrypts → api's sidecar decrypts

## Start Sidecar Proxy
```bash
# Built-in proxy
consul connect proxy -sidecar-for web

# Envoy proxy (production)
consul connect envoy -sidecar-for web
```

## Intentions (Authorization)
```bash
# Allow web → api
consul intention create web api

# Deny db → web
consul intention create -deny db web

# List intentions
consul intention list

# Check if allowed
consul intention check web api
```

## Intentions via Config
```hcl
# /etc/consul.d/intentions.hcl
Kind = "service-intentions"
Name = "api"
Sources = [
  {
    Name   = "web"
    Action = "allow"
  },
  {
    Name   = "*"
    Action = "deny"
  }
]
```

## Traffic Management
```hcl
# Service router — route by path
Kind = "service-router"
Name = "api"
Routes = [
  {
    Match {
      HTTP { PathPrefix = "/v2/" }
    }
    Destination { Service = "api-v2" }
  }
]

# Service splitter — canary deployment
Kind = "service-splitter"
Name = "api"
Splits = [
  { Weight = 90, Service = "api" },
  { Weight = 10, Service = "api-v2" }
]
```
EOF
}

cmd_acl() {
    cat << 'EOF'
# ACL System

## Bootstrap
```bash
# Initialize ACL system (creates bootstrap token)
consul acl bootstrap

# Output:
# SecretID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# Save this! It's the root token.
```

## Server Config for ACL
```hcl
acl {
  enabled        = true
  default_policy = "deny"
  enable_token_persistence = true
  tokens {
    initial_management = "bootstrap-token-here"
    agent = "agent-token-here"
  }
}
```

## Policies
```bash
# Create policy from file
consul acl policy create -name "read-all" -rules @read-policy.hcl

# List policies
consul acl policy list
```

Policy file (`read-policy.hcl`):
```hcl
# Read all services
service_prefix "" {
  policy = "read"
}

# Read all KV
key_prefix "" {
  policy = "read"
}

# Read all nodes
node_prefix "" {
  policy = "read"
}
```

## Tokens
```bash
# Create token with policy
consul acl token create -description "API reader" -policy-name "read-all"

# List tokens
consul acl token list

# Use token with API
curl -H "X-Consul-Token: your-token" http://localhost:8500/v1/kv/config/

# Use token with CLI
CONSUL_HTTP_TOKEN=your-token consul kv get config/key
```

## Common Policies
```hcl
# Agent policy (for client agents)
node_prefix "" { policy = "write" }
service_prefix "" { policy = "read" }

# Service write policy (for registering services)
service "web" { policy = "write" }
service "web-sidecar-proxy" { policy = "write" }
node_prefix "" { policy = "read" }

# KV write policy
key_prefix "config/" { policy = "write" }
```
EOF
}

cmd_template() {
    cat << 'EOF'
# consul-template

## What is consul-template?
A daemon that queries Consul and renders templates when data changes.
Use it to dynamically update config files (nginx, haproxy, etc.)

## Install
```bash
# Download
wget https://releases.hashicorp.com/consul-template/0.37.4/consul-template_0.37.4_linux_amd64.zip
unzip consul-template_0.37.4_linux_amd64.zip
mv consul-template /usr/local/bin/
```

## Template Syntax (.ctmpl)
```
# /etc/consul-template/nginx.ctmpl
upstream backend {
{{range service "web"}}
    server {{.Address}}:{{.Port}};
{{end}}
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

## Run consul-template
```bash
consul-template \
  -template "/etc/consul-template/nginx.ctmpl:/etc/nginx/conf.d/backend.conf:nginx -s reload"
```

Format: `-template "source:destination:command"`

## Config File
```hcl
# /etc/consul-template/config.hcl
consul {
  address = "127.0.0.1:8500"
  token   = "your-consul-token"
}

template {
  source      = "/etc/consul-template/nginx.ctmpl"
  destination = "/etc/nginx/conf.d/backend.conf"
  command     = "systemctl reload nginx"
}

template {
  source      = "/etc/consul-template/haproxy.ctmpl"
  destination = "/etc/haproxy/haproxy.cfg"
  command     = "systemctl reload haproxy"
}
```

## Template Functions
```
# KV lookup
{{ key "config/db/host" }}

# Service query
{{ range service "web" }}
  {{ .Name }} {{ .Address }}:{{ .Port }}
{{ end }}

# With tag filter
{{ range service "v2.web" }}...{{ end }}

# Vault secret
{{ with secret "secret/data/myapp" }}
  DB_PASS={{ .Data.data.password }}
{{ end }}

# Environment variable
{{ env "HOME" }}

# Conditional
{{ if key "config/maintenance" }}
  # maintenance mode
{{ else }}
  # normal mode
{{ end }}
```
EOF
}

cmd_ops() {
    cat << 'EOF'
# Consul Operations

## Cluster Status
```bash
# List members
consul members

# List with detailed info
consul members -detailed

# Raft peer list
consul operator raft list-peers

# Leader
consul operator raft list-peers | grep leader
```

## Snapshots
```bash
# Save snapshot (backup)
consul snapshot save consul-backup-$(date +%Y%m%d).snap

# Restore snapshot
consul snapshot restore consul-backup-20260324.snap

# Inspect snapshot
consul snapshot inspect consul-backup-20260324.snap
```

## Maintenance Mode
```bash
# Enable maintenance on a node
consul maint -enable -reason "Patching OS"

# Disable maintenance
consul maint -disable

# Service-level maintenance
consul maint -enable -service-id web-1 -reason "Deploying v2"
```

## Leave Cluster Gracefully
```bash
# Client node leaving
consul leave

# Force remove failed node
consul force-leave failed-node-name
consul force-leave -prune failed-node-name  # Remove from catalog too
```

## Monitor and Debug
```bash
# Live log streaming
consul monitor -log-level=debug

# Debug bundle
consul debug -duration=30s -interval=5s
# Creates consul-debug-*.tar.gz

# DNS test
dig @127.0.0.1 -p 8600 web.service.consul

# API test
curl -s http://localhost:8500/v1/status/leader
```

## Autopilot (Server Management)
```bash
# Check autopilot health
consul operator autopilot state

# Config
consul operator autopilot set-config \
  -cleanup-dead-servers=true \
  -last-contact-threshold=200ms \
  -server-stabilization-time=10s
```

## Backup Strategy
```bash
# Cron: daily snapshots, keep 7 days
0 2 * * * consul snapshot save /backup/consul-$(date +\%Y\%m\%d).snap && find /backup -name "consul-*.snap" -mtime +7 -delete
```
EOF
}

case "${1:-help}" in
    intro)    cmd_intro ;;
    agent)    cmd_agent ;;
    services) cmd_services ;;
    kv)       cmd_kv ;;
    connect)  cmd_connect ;;
    acl)      cmd_acl ;;
    template) cmd_template ;;
    ops)      cmd_ops ;;
    help|-h)  show_help ;;
    version|-v) echo "consul v$VERSION" ;;
    *)        echo "Unknown: $1"; show_help ;;
esac
