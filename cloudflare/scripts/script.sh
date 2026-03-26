#!/bin/bash
# Cloudflare - CDN, DNS & Security Platform Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CLOUDFLARE REFERENCE                           ║
║          CDN, DNS, Security & Edge Platform                 ║
╚══════════════════════════════════════════════════════════════╝

Cloudflare is the world's largest CDN/security platform. It
proxies ~20% of all internet traffic, providing DDoS protection,
CDN, DNS, SSL, and edge computing.

PRODUCT SUITE:
  CDN              Content delivery & caching
  DNS              Fastest authoritative DNS (1.1.1.1)
  WAF              Web Application Firewall
  DDoS             Automatic DDoS mitigation
  SSL/TLS          Free SSL certificates
  Workers          Serverless edge computing
  Pages            Static site hosting + SSR
  R2               S3-compatible object storage (no egress fees!)
  D1               SQLite at the edge
  KV               Key-value storage at the edge
  Queues           Message queues
  Tunnels          Expose local services (no port forwarding)
  Zero Trust       ZTNA, Gateway, Access
  Images           Image optimization & delivery
  Stream           Video streaming

FREE TIER:
  Unlimited CDN bandwidth, 100K Workers/day,
  DNS, SSL, basic DDoS, 5GB R2, basic WAF
EOF
}

cmd_workers() {
cat << 'EOF'
WORKERS & PAGES
=================

WORKERS (serverless at the edge):
  # Install Wrangler CLI
  npm install -g wrangler
  wrangler login

  # Create project
  wrangler init my-worker
  cd my-worker

  # src/index.ts
  export default {
    async fetch(request, env, ctx) {
      const url = new URL(request.url);

      if (url.pathname === "/api/hello") {
        return Response.json({ message: "Hello from the edge!" });
      }

      if (url.pathname === "/api/kv") {
        const value = await env.MY_KV.get("key");
        return Response.json({ value });
      }

      return new Response("Not found", { status: 404 });
    },
  };

  # Deploy
  wrangler deploy

  # Dev mode
  wrangler dev

KV (key-value at edge):
  wrangler kv namespace create MY_KV
  wrangler kv key put --namespace-id=xxx "key" "value"
  # Bindings in wrangler.toml:
  [[kv_namespaces]]
  binding = "MY_KV"
  id = "abc123"

R2 (object storage):
  wrangler r2 bucket create my-bucket
  # In Worker:
  await env.MY_BUCKET.put("file.txt", data);
  const obj = await env.MY_BUCKET.get("file.txt");

D1 (SQLite at edge):
  wrangler d1 create my-db
  wrangler d1 execute my-db --command "CREATE TABLE users (id INT, name TEXT)"
  # In Worker:
  const { results } = await env.DB.prepare("SELECT * FROM users").all();

PAGES (static + SSR):
  # Connect GitHub repo
  wrangler pages project create my-site

  # Or deploy directly
  wrangler pages deploy ./dist

  # Functions (Pages Functions = Workers)
  # functions/api/hello.ts
  export async function onRequest(context) {
    return Response.json({ hello: "world" });
  }
  # Auto-deployed at /api/hello
EOF
}

cmd_security() {
cat << 'EOF'
DNS, TUNNELS & SECURITY
==========================

DNS:
  # Fastest authoritative DNS
  # Add domain → change nameservers to Cloudflare's
  # Then manage records via API or dashboard

  # API: create record
  curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
    -H "Authorization: Bearer $CF_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"type":"A","name":"app","content":"1.2.3.4","proxied":true}'

  # Proxied = orange cloud = traffic goes through Cloudflare
  # DNS-only = gray cloud = direct to origin

TUNNELS (expose local services):
  # No port forwarding, no public IP needed!
  cloudflared tunnel login
  cloudflared tunnel create my-tunnel
  cloudflared tunnel route dns my-tunnel app.example.com

  # config.yml
  tunnel: <tunnel-id>
  credentials-file: /root/.cloudflared/<tunnel-id>.json
  ingress:
    - hostname: app.example.com
      service: http://localhost:3000
    - hostname: api.example.com
      service: http://localhost:8080
    - service: http_status:404

  cloudflared tunnel run my-tunnel

  # Docker
  docker run cloudflare/cloudflared tunnel --no-autoupdate run \
    --token $TUNNEL_TOKEN

WAF RULES:
  # Dashboard → Security → WAF
  # Custom rules:
  (http.request.uri.path contains "/admin" and
   ip.src ne 1.2.3.4)
  → Block

  # Rate limiting:
  (http.request.uri.path eq "/api/login")
  → Rate limit: 5 requests per minute per IP

  # Bot management:
  (cf.bot_management.score lt 30)
  → Challenge

ZERO TRUST:
  # Cloudflare Access (replace VPN)
  # Protect internal apps with SSO
  # Dashboard → Zero Trust → Access → Applications

  # Users authenticate via Google/Okta/SAML
  # No VPN needed — apps accessible via browser

  # Gateway (DNS filtering)
  # Block malware domains, phishing, etc.

PAGE RULES / CACHE:
  # Cache everything
  Cache Level: Cache Everything
  Edge Cache TTL: 1 month

  # Redirect
  example.com/* → https://www.example.com/$1

  # Always HTTPS
  http://*example.com/* → https://$1example.com/$2

  # API: purge cache
  curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/purge_cache" \
    -H "Authorization: Bearer $CF_TOKEN" \
    -d '{"purge_everything":true}'

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Cloudflare - CDN, DNS & Security Platform Reference

Commands:
  intro      Product suite, free tier
  workers    Workers, KV, R2, D1, Pages
  security   DNS, Tunnels, WAF, Zero Trust, cache

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  workers)  cmd_workers ;;
  security) cmd_security ;;
  help|*)   show_help ;;
esac
