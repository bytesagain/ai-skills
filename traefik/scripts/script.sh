#!/bin/bash
# Traefik - Cloud-Native Reverse Proxy Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TRAEFIK REFERENCE                              ║
║          The Cloud-Native Edge Router                       ║
╚══════════════════════════════════════════════════════════════╝

Traefik is a modern reverse proxy and load balancer designed
for microservices. It auto-discovers services from Docker,
Kubernetes, and other orchestrators.

KEY FEATURES:
  Auto-discovery   Detects services from Docker/K8s labels
  Let's Encrypt    Automatic HTTPS certificates
  Middlewares      Rate limiting, auth, headers, retry
  Dashboard        Real-time monitoring UI
  Metrics          Prometheus, Datadog, InfluxDB
  TCP/UDP          Not just HTTP — supports L4
  gRPC             Native gRPC support
  Canary           Traffic splitting for deployments
  Plugins          Extensible via Go plugins

TRAEFIK vs NGINX vs CADDY vs HAProxy:
  ┌──────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Traefik  │ Nginx    │ Caddy    │ HAProxy  │
  ├──────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Auto-discover│ Yes      │ No       │ No       │ No       │
  │ Auto HTTPS   │ Yes      │ Manual   │ Yes      │ No       │
  │ Docker native│ Yes      │ Manual   │ Plugin   │ No       │
  │ K8s Ingress  │ Yes      │ Yes      │ Yes      │ Yes      │
  │ Config       │ Labels   │ Files    │ Caddyfile│ Files    │
  │ Performance  │ Good     │ Fastest  │ Good     │ Fastest  │
  │ Dashboard    │ Built-in │ Plus     │ API      │ Stats    │
  └──────────────┴──────────┴──────────┴──────────┴──────────┘
EOF
}

cmd_docker() {
cat << 'EOF'
DOCKER CONFIGURATION
======================

DOCKER COMPOSE (traefik + services):
  services:
    traefik:
      image: traefik:v3.0
      command:
        - "--api.dashboard=true"
        - "--providers.docker=true"
        - "--providers.docker.exposedbydefault=false"
        - "--entrypoints.web.address=:80"
        - "--entrypoints.websecure.address=:443"
        - "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"
        - "--certificatesresolvers.le.acme.email=admin@example.com"
        - "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json"
      ports:
        - "80:80"
        - "443:443"
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock:ro
        - letsencrypt:/letsencrypt
      labels:
        # Dashboard
        - "traefik.enable=true"
        - "traefik.http.routers.dashboard.rule=Host(`traefik.example.com`)"
        - "traefik.http.routers.dashboard.service=api@internal"
        - "traefik.http.routers.dashboard.middlewares=auth"
        - "traefik.http.middlewares.auth.basicauth.users=admin:$$apr1$$xyz"

    app:
      image: myapp:latest
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.app.rule=Host(`app.example.com`)"
        - "traefik.http.routers.app.entrypoints=websecure"
        - "traefik.http.routers.app.tls.certresolver=le"
        - "traefik.http.services.app.loadbalancer.server.port=3000"

    api:
      image: myapi:latest
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.api.rule=Host(`api.example.com`)"
        - "traefik.http.routers.api.entrypoints=websecure"
        - "traefik.http.routers.api.tls.certresolver=le"
        # Rate limiting middleware
        - "traefik.http.routers.api.middlewares=ratelimit"
        - "traefik.http.middlewares.ratelimit.ratelimit.average=100"
        - "traefik.http.middlewares.ratelimit.ratelimit.burst=50"

HTTP → HTTPS REDIRECT:
  labels:
    - "traefik.http.routers.app-http.rule=Host(`app.example.com`)"
    - "traefik.http.routers.app-http.entrypoints=web"
    - "traefik.http.routers.app-http.middlewares=https-redirect"
    - "traefik.http.middlewares.https-redirect.redirectscheme.scheme=https"

PATH-BASED ROUTING:
  labels:
    - "traefik.http.routers.app.rule=Host(`example.com`) && PathPrefix(`/app`)"
    - "traefik.http.middlewares.strip.stripprefix.prefixes=/app"
    - "traefik.http.routers.app.middlewares=strip"

WEIGHTED ROUTING (canary):
  labels:
    - "traefik.http.services.app.loadbalancer.server.port=3000"
    - "traefik.http.services.app.loadbalancer.server.weight=90"
    # v2 gets 10% traffic
    - "traefik.http.services.app-v2.loadbalancer.server.weight=10"
EOF
}

cmd_k8s() {
cat << 'EOF'
KUBERNETES & MIDDLEWARES
==========================

KUBERNETES INGRESSROUTE:
  apiVersion: traefik.io/v1alpha1
  kind: IngressRoute
  metadata:
    name: my-app
  spec:
    entryPoints:
      - websecure
    routes:
      - match: Host(`app.example.com`)
        kind: Rule
        services:
          - name: my-app-service
            port: 80
        middlewares:
          - name: ratelimit
    tls:
      certResolver: le

  ---
  apiVersion: traefik.io/v1alpha1
  kind: Middleware
  metadata:
    name: ratelimit
  spec:
    rateLimit:
      average: 100
      burst: 50

MIDDLEWARES:
  # Headers
  - "traefik.http.middlewares.security.headers.stsSeconds=31536000"
  - "traefik.http.middlewares.security.headers.forceSTSHeader=true"
  - "traefik.http.middlewares.security.headers.contentTypeNosniff=true"
  - "traefik.http.middlewares.security.headers.frameDeny=true"

  # Compress
  - "traefik.http.middlewares.compress.compress=true"

  # IP whitelist
  - "traefik.http.middlewares.ipallow.ipallowlist.sourcerange=10.0.0.0/8"

  # Retry
  - "traefik.http.middlewares.retry.retry.attempts=3"
  - "traefik.http.middlewares.retry.retry.initialinterval=100ms"

  # Circuit breaker
  - "traefik.http.middlewares.cb.circuitbreaker.expression=LatencyAtQuantileMS(50.0) > 100"

  # Forward auth (external auth service)
  - "traefik.http.middlewares.auth.forwardauth.address=http://auth:4181"

  # Chain middlewares
  - "traefik.http.routers.app.middlewares=compress,security,ratelimit"

FILE PROVIDER (static config):
  # traefik.yml
  entryPoints:
    web:
      address: ":80"
    websecure:
      address: ":443"
  providers:
    file:
      directory: /etc/traefik/dynamic/

  # /etc/traefik/dynamic/routes.yml
  http:
    routers:
      my-app:
        rule: "Host(`app.example.com`)"
        service: my-app
        tls:
          certResolver: le
    services:
      my-app:
        loadBalancer:
          servers:
            - url: "http://192.168.1.10:3000"
            - url: "http://192.168.1.11:3000"

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Traefik - Cloud-Native Reverse Proxy Reference

Commands:
  intro    Overview, comparison
  docker   Docker Compose, labels, HTTPS, canary
  k8s      Kubernetes IngressRoute, middlewares, file config

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  docker) cmd_docker ;;
  k8s)    cmd_k8s ;;
  help|*) show_help ;;
esac
