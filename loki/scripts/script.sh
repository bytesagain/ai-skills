#!/bin/bash
# Loki - Log Aggregation System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              LOKI REFERENCE                                 ║
║          Like Prometheus, But For Logs                      ║
╚══════════════════════════════════════════════════════════════╝

Grafana Loki is a horizontally-scalable log aggregation system.
Unlike Elasticsearch, Loki only indexes labels (not full text),
making it much cheaper and simpler to operate.

LOKI vs ELK:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ Loki         │ ELK Stack    │
  ├──────────────┼──────────────┼──────────────┤
  │ Indexing     │ Labels only  │ Full text    │
  │ Storage cost │ Low          │ High         │
  │ Query lang   │ LogQL        │ KQL/Lucene   │
  │ Complexity   │ Simple       │ Complex      │
  │ Grafana      │ Native       │ Plugin       │
  │ K8s native   │ Yes          │ Via Filebeat │
  │ Scale        │ Horizontal   │ Horizontal   │
  └──────────────┴──────────────┴──────────────┘

ARCHITECTURE:
  Promtail/Alloy → Loki → Grafana
  (agent)          (store)  (UI)

  Distributor    Receives and validates logs
  Ingester       Builds compressed chunks
  Querier        Executes LogQL queries
  Compactor      Optimizes stored chunks
  Index Gateway  Serves index queries
EOF
}

cmd_logql() {
cat << 'EOF'
LOGQL QUERY LANGUAGE
======================

LOG STREAM SELECTORS:
  {job="nginx"}                       # By job label
  {namespace="prod", app="web"}       # Multiple labels
  {pod=~"web-.*"}                     # Regex match
  {container!="sidecar"}              # Not equal
  {namespace=~"prod|staging"}         # Regex OR

LINE FILTERS:
  {job="nginx"} |= "error"           # Contains "error"
  {job="nginx"} != "healthcheck"      # Does not contain
  {job="nginx"} |~ "4[0-9]{2}"       # Regex match
  {job="nginx"} !~ "GET /health"      # Regex not match

  # Chain filters
  {job="nginx"} |= "error" != "404" |~ "timeout|refused"

PARSER:
  {job="nginx"} | json                # Parse JSON logs
  {job="nginx"} | logfmt              # Parse logfmt
  {job="nginx"} | pattern "<ip> - - [<_>] \"<method> <path> <_>\" <status>"
  {job="nginx"} | regexp "(?P<ip>\\S+) .* (?P<status>\\d{3})"

  # After parsing, filter on extracted fields
  {job="nginx"} | json | level="error"
  {job="nginx"} | json | latency_ms > 500
  {job="nginx"} | json | status >= 400

AGGREGATIONS:
  # Count errors per minute
  count_over_time({job="nginx"} |= "error" [5m])

  # Rate of log lines
  rate({job="nginx"} [1m])

  # Bytes rate
  bytes_rate({job="nginx"} [5m])

  # Top labels by volume
  sum by (level) (count_over_time({job="app"} | json [1h]))

  # P99 latency from logs
  quantile_over_time(0.99, {job="app"} | json | unwrap latency_ms [5m])

  # Group by and sort
  topk(10, sum by (status) (count_over_time({job="nginx"} | json [1h])))
EOF
}

cmd_config() {
cat << 'EOF'
DEPLOYMENT & CONFIG
=====================

HELM INSTALL:
  helm repo add grafana https://grafana.github.io/helm-charts
  helm install loki grafana/loki-stack \
    --set promtail.enabled=true \
    --set grafana.enabled=true \
    -n monitoring --create-namespace

  # Loki Simple Scalable (recommended for production)
  helm install loki grafana/loki \
    --set deploymentMode=SimpleScalable \
    --set backend.replicas=2 \
    --set read.replicas=2 \
    --set write.replicas=3 \
    -n monitoring

LOKI CONFIG:
  # loki.yaml
  auth_enabled: false
  server:
    http_listen_port: 3100
  common:
    path_prefix: /loki
    storage:
      filesystem:
        chunks_directory: /loki/chunks
        rules_directory: /loki/rules
    replication_factor: 1
    ring:
      kvstore:
        store: inmemory
  schema_config:
    configs:
      - from: 2024-01-01
        store: tsdb
        object_store: filesystem
        schema: v13
        index:
          prefix: index_
          period: 24h
  limits_config:
    retention_period: 30d
    max_query_length: 721h
  storage_config:
    tsdb_shipper:
      active_index_directory: /loki/tsdb-index
      cache_location: /loki/tsdb-cache

PROMTAIL CONFIG:
  # promtail.yaml
  server:
    http_listen_port: 9080
  positions:
    filename: /tmp/positions.yaml
  clients:
    - url: http://loki:3100/loki/api/v1/push
  scrape_configs:
    - job_name: kubernetes
      kubernetes_sd_configs:
        - role: pod
      relabel_configs:
        - source_labels: [__meta_kubernetes_pod_label_app]
          target_label: app
        - source_labels: [__meta_kubernetes_namespace]
          target_label: namespace

GRAFANA ALLOY (replaces Promtail):
  loki.source.kubernetes "pods" {
    targets    = discovery.kubernetes.pods.targets
    forward_to = [loki.write.default.receiver]
  }
  loki.write "default" {
    endpoint {
      url = "http://loki:3100/loki/api/v1/push"
    }
  }

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Loki - Log Aggregation System Reference

Commands:
  intro    Architecture, Loki vs ELK
  logql    LogQL queries, parsers, aggregations
  config   Deployment, Loki/Promtail config, Alloy

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  logql)  cmd_logql ;;
  config) cmd_config ;;
  help|*) show_help ;;
esac
