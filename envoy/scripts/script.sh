#!/bin/bash
# Envoy Proxy - Cloud-Native Edge/Service Proxy Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ENVOY PROXY REFERENCE                          ║
║          Cloud-Native L7 Proxy and Service Mesh             ║
╚══════════════════════════════════════════════════════════════╝

Envoy is a high-performance L4/L7 proxy designed for cloud-native
applications. It's the data plane for Istio, AWS App Mesh, and
many service mesh implementations.

KEY FEATURES:
  L7 proxy       HTTP/2, gRPC, WebSocket native support
  Load balancing Round robin, least request, ring hash, random
  Service mesh   Sidecar proxy pattern
  Observability  Built-in stats, tracing, access logging
  Dynamic config xDS API for runtime configuration
  Rate limiting  Local and global rate limiting
  Circuit breaker Outlier detection + ejection
  TLS            Automatic mTLS, SNI, OCSP stapling

ARCHITECTURE:
  Downstream → Listener → Filter Chain → Router → Cluster → Upstream

  Listener     Port + protocol binding
  Filter       Request/response processing (HTTP, TCP, auth)
  Route        URL path → cluster mapping
  Cluster      Group of upstream endpoints
  Endpoint     Individual backend server

ENVOY vs NGINX vs HAPROXY:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Envoy    │ Nginx    │ HAProxy  │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Dynamic conf │ xDS API  │ Reload   │ Reload   │
  │ gRPC native  │ Yes      │ Limited  │ No       │
  │ HTTP/2       │ Full     │ Full     │ Full     │
  │ Observability│ Built-in │ Module   │ Built-in │
  │ Service mesh │ Standard │ No       │ No       │
  │ Hot restart  │ Yes      │ Reload   │ Reload   │
  │ Wasm plugins │ Yes      │ No       │ No       │
  │ Performance  │ High     │ Highest  │ Highest  │
  └──────────────┴──────────┴──────────┴──────────┘
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION
===============

BASIC HTTP PROXY:
  static_resources:
    listeners:
    - name: http_listener
      address:
        socket_address:
          address: 0.0.0.0
          port_value: 8080
      filter_chains:
      - filters:
        - name: envoy.filters.network.http_connection_manager
          typed_config:
            "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
            stat_prefix: ingress_http
            route_config:
              name: local_route
              virtual_hosts:
              - name: backend
                domains: ["*"]
                routes:
                - match:
                    prefix: "/"
                  route:
                    cluster: backend_service

    clusters:
    - name: backend_service
      connect_timeout: 5s
      type: STRICT_DNS
      lb_policy: ROUND_ROBIN
      load_assignment:
        cluster_name: backend_service
        endpoints:
        - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  address: backend
                  port_value: 8080

PATH-BASED ROUTING:
  routes:
  - match:
      prefix: "/api/"
    route:
      cluster: api_service
  - match:
      prefix: "/static/"
    route:
      cluster: static_service
  - match:
      safe_regex:
        regex: "/users/[0-9]+"
    route:
      cluster: user_service
  - match:
      prefix: "/"
    route:
      cluster: frontend

HEADER-BASED ROUTING:
  routes:
  - match:
      prefix: "/"
      headers:
      - name: "x-api-version"
        exact_match: "v2"
    route:
      cluster: api_v2
  - match:
      prefix: "/"
    route:
      cluster: api_v1

WEIGHTED ROUTING (canary):
  routes:
  - match:
      prefix: "/"
    route:
      weighted_clusters:
        clusters:
        - name: service_v1
          weight: 90
        - name: service_v2
          weight: 10
EOF
}

cmd_features() {
cat << 'EOF'
ADVANCED FEATURES
===================

CIRCUIT BREAKER:
  clusters:
  - name: backend
    circuit_breakers:
      thresholds:
      - max_connections: 1000
        max_pending_requests: 500
        max_requests: 2000
        max_retries: 3

OUTLIER DETECTION (health-based ejection):
  clusters:
  - name: backend
    outlier_detection:
      consecutive_5xx: 5
      interval: 10s
      base_ejection_time: 30s
      max_ejection_percent: 50
      enforcing_consecutive_5xx: 100

RETRIES:
  routes:
  - match: {prefix: "/api/"}
    route:
      cluster: api
      retry_policy:
        retry_on: "5xx,reset,connect-failure"
        num_retries: 3
        per_try_timeout: 2s
        retry_back_off:
          base_interval: 0.5s
          max_interval: 5s

RATE LIMITING:
  http_filters:
  - name: envoy.filters.http.local_ratelimit
    typed_config:
      stat_prefix: http_local_rate_limiter
      token_bucket:
        max_tokens: 100
        tokens_per_fill: 100
        fill_interval: 60s

TIMEOUTS:
  routes:
  - match: {prefix: "/"}
    route:
      cluster: backend
      timeout: 30s
      idle_timeout: 300s

TLS TERMINATION:
  listeners:
  - filter_chains:
    - transport_socket:
        name: envoy.transport_sockets.tls
        typed_config:
          common_tls_context:
            tls_certificates:
            - certificate_chain:
                filename: /etc/envoy/cert.pem
              private_key:
                filename: /etc/envoy/key.pem

mTLS (mutual TLS):
  transport_socket:
    typed_config:
      common_tls_context:
        tls_certificates: [...]
        validation_context:
          trusted_ca:
            filename: /etc/envoy/ca.pem

ACCESS LOGGING:
  http_connection_manager:
    access_log:
    - name: envoy.access_loggers.file
      typed_config:
        path: /var/log/envoy/access.log
        log_format:
          json_format:
            timestamp: "%START_TIME%"
            method: "%REQ(:METHOD)%"
            path: "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
            status: "%RESPONSE_CODE%"
            duration: "%DURATION%"
            upstream: "%UPSTREAM_HOST%"

OBSERVABILITY:
  # Stats endpoint
  admin:
    address:
      socket_address:
        address: 0.0.0.0
        port_value: 9901

  # Prometheus: GET :9901/stats/prometheus
  # Tracing: Zipkin, Jaeger, OpenTelemetry integrations

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Envoy Proxy - Cloud-Native Service Proxy Reference

Commands:
  intro     Overview, architecture, comparison
  config    Listeners, routing, clusters, weighted
  features  Circuit breaker, retries, rate limit, TLS, logging

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  config)   cmd_config ;;
  features) cmd_features ;;
  help|*)   show_help ;;
esac
