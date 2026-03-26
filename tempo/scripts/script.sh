#!/bin/bash
# Tempo - Distributed Tracing Backend Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TEMPO REFERENCE                                ║
║          Grafana Distributed Tracing Backend                ║
╚══════════════════════════════════════════════════════════════╝

Grafana Tempo is a high-volume distributed tracing backend.
It only requires object storage (S3, GCS, Azure) — no indexing
database needed, making it cost-effective at scale.

THE OBSERVABILITY STACK:
  Metrics  → Prometheus/Mimir    → Grafana
  Logs     → Loki                → Grafana
  Traces   → Tempo               → Grafana
  Profiles → Pyroscope           → Grafana

TEMPO vs JAEGER:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ Tempo        │ Jaeger       │
  ├──────────────┼──────────────┼──────────────┤
  │ Storage      │ Object store │ Elasticsearch│
  │ Index needed │ No           │ Yes          │
  │ Cost         │ Very low     │ High         │
  │ Query        │ TraceQL      │ API/UI       │
  │ Protocols    │ OTLP, Jaeger,│ Jaeger       │
  │              │ Zipkin       │              │
  │ Grafana      │ Native       │ Plugin       │
  │ Scale        │ Massive      │ Moderate     │
  └──────────────┴──────────────┴──────────────┘

PROTOCOLS SUPPORTED:
  OTLP/gRPC       Port 4317     (OpenTelemetry native)
  OTLP/HTTP       Port 4318
  Jaeger Thrift   Port 14268
  Zipkin          Port 9411
  Jaeger gRPC     Port 14250
EOF
}

cmd_traceql() {
cat << 'EOF'
TRACEQL QUERY LANGUAGE
========================

BASIC QUERIES:
  # Find traces by service
  {resource.service.name = "frontend"}

  # By span name
  {name = "HTTP GET"}

  # By status
  {status = error}

  # By duration
  {duration > 500ms}
  {duration > 2s}

  # By attribute
  {span.http.status_code = 500}
  {span.http.method = "POST"}
  {span.db.system = "postgresql"}

COMBINING:
  # Service with errors > 1s
  {resource.service.name = "api" && status = error && duration > 1s}

  # HTTP 500s on specific path
  {span.http.status_code = 500 && span.http.url =~ "/api/.*"}

  # Database slow queries
  {span.db.system = "mysql" && duration > 100ms}

STRUCTURAL QUERIES:
  # Parent-child relationships
  {resource.service.name = "frontend"} >> {resource.service.name = "api"}

  # Find traces where frontend calls a slow API
  {resource.service.name = "frontend"} >> {resource.service.name = "api" && duration > 2s}

  # Sibling spans
  {name = "HTTP GET"} ~ {name = "cache.lookup"}

AGGREGATIONS:
  # Average duration by service
  {status = error} | avg(duration) by (resource.service.name)

  # Count errors
  {status = error} | count() by (resource.service.name)

  # P99 latency
  {resource.service.name = "api"} | quantile_over_time(duration, 0.99)

GRAFANA EXPLORE:
  1. Go to Explore → Select Tempo datasource
  2. Use TraceQL tab for queries
  3. Click trace ID to see waterfall view
  4. "Logs for this span" links to Loki
  5. "Metrics" links to Prometheus
EOF
}

cmd_config() {
cat << 'EOF'
DEPLOYMENT & INSTRUMENTATION
===============================

HELM INSTALL:
  helm repo add grafana https://grafana.github.io/helm-charts
  helm install tempo grafana/tempo \
    -n monitoring --create-namespace

  # Distributed mode (production)
  helm install tempo grafana/tempo-distributed \
    --set storage.trace.backend=s3 \
    --set storage.trace.s3.bucket=tempo-traces \
    -n monitoring

TEMPO CONFIG:
  # tempo.yaml
  server:
    http_listen_port: 3200
  distributor:
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
      jaeger:
        protocols:
          thrift_http:
            endpoint: 0.0.0.0:14268
      zipkin:
        endpoint: 0.0.0.0:9411
  storage:
    trace:
      backend: s3
      s3:
        bucket: tempo-traces
        endpoint: s3.amazonaws.com
      wal:
        path: /var/tempo/wal
      local:
        path: /var/tempo/blocks

OPENTELEMETRY SDK (instrument your app):
  # Python
  pip install opentelemetry-api opentelemetry-sdk \
    opentelemetry-exporter-otlp

  from opentelemetry import trace
  from opentelemetry.sdk.trace import TracerProvider
  from opentelemetry.sdk.trace.export import BatchSpanProcessor
  from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

  provider = TracerProvider()
  processor = BatchSpanProcessor(OTLPSpanExporter(endpoint="http://tempo:4317"))
  provider.add_span_processor(processor)
  trace.set_tracer_provider(provider)

  tracer = trace.get_tracer("my-service")
  with tracer.start_as_current_span("process-request") as span:
      span.set_attribute("user.id", "123")
      # ... your code

  # Node.js
  npm install @opentelemetry/api @opentelemetry/sdk-node \
    @opentelemetry/exporter-trace-otlp-grpc

GRAFANA DATASOURCE:
  datasources:
    - name: Tempo
      type: tempo
      url: http://tempo:3200
      jsonData:
        tracesToLogsV2:
          datasourceUid: loki
          filterByTraceID: true
        tracesToMetrics:
          datasourceUid: prometheus
        serviceMap:
          datasourceUid: prometheus

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Tempo - Distributed Tracing Backend Reference

Commands:
  intro     Architecture, vs Jaeger, protocols
  traceql   TraceQL queries, structural, aggregations
  config    Deploy, instrumentation, Grafana setup

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  traceql) cmd_traceql ;;
  config)  cmd_config ;;
  help|*)  show_help ;;
esac
