#!/bin/bash
# TimescaleDB - Time-Series Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TIMESCALEDB REFERENCE                          ║
║          PostgreSQL for Time-Series Data                    ║
╚══════════════════════════════════════════════════════════════╝

TimescaleDB is a PostgreSQL extension that turns Postgres into
a high-performance time-series database. Full SQL, no new query
language, just faster time-series at scale.

KEY FEATURES:
  Hypertables      Auto-partitioned tables by time
  Compression      10-40x storage reduction
  Continuous aggs  Materialized views that auto-refresh
  Retention        Auto-drop old data by policy
  Real-time aggs   Combine materialized + recent data
  Full SQL         It's just PostgreSQL
  Hyperfunctions   Time-series-specific SQL functions

TIMESCALEDB vs INFLUXDB vs PROMETHEUS:
  ┌──────────────┬────────────┬──────────┬──────────┐
  │ Feature      │ Timescale  │ InfluxDB │Prometheus│
  ├──────────────┼────────────┼──────────┼──────────┤
  │ Query lang   │ SQL        │ Flux/SQL │ PromQL   │
  │ Base DB      │ PostgreSQL │ Custom   │ Custom   │
  │ JOINs        │ Yes        │ Limited  │ No       │
  │ Compression  │ Native     │ Native   │ Native   │
  │ HA           │ PG native  │ Paid     │ Thanos   │
  │ Best for     │ General TS │ Metrics  │ Monitoring│
  │ Retention    │ Policy     │ Policy   │ CLI flag │
  │ Ecosystem    │ PG tools   │ Telegraf │ Exporters│
  └──────────────┴────────────┴──────────┴──────────┘

INSTALL:
  # Docker (easiest)
  docker run -d --name timescaledb \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=password \
    timescale/timescaledb:latest-pg16

  # Extension on existing PostgreSQL
  CREATE EXTENSION IF NOT EXISTS timescaledb;
EOF
}

cmd_tables() {
cat << 'EOF'
HYPERTABLES & QUERIES
========================

CREATE HYPERTABLE:
  CREATE TABLE metrics (
      time        TIMESTAMPTZ NOT NULL,
      device_id   TEXT NOT NULL,
      temperature DOUBLE PRECISION,
      humidity    DOUBLE PRECISION,
      cpu_usage   DOUBLE PRECISION
  );

  -- Convert to hypertable (auto-partitions by time)
  SELECT create_hypertable('metrics', 'time');

  -- With custom chunk interval (default 7 days)
  SELECT create_hypertable('metrics', 'time',
      chunk_time_interval => INTERVAL '1 day');

  -- Space partitioning (for multi-tenant)
  SELECT create_hypertable('metrics', 'time',
      partitioning_column => 'device_id',
      number_partitions => 4);

INSERT:
  INSERT INTO metrics VALUES
  (NOW(), 'sensor-1', 22.5, 60.1, 45.2),
  (NOW(), 'sensor-2', 23.1, 55.3, 32.8);

  -- Bulk insert with COPY (fastest)
  COPY metrics FROM '/data/metrics.csv' CSV HEADER;

TIME-SERIES QUERIES:
  -- Time bucket (GROUP BY time intervals)
  SELECT time_bucket('5 minutes', time) AS bucket,
         device_id,
         AVG(temperature) AS avg_temp,
         MAX(temperature) AS max_temp,
         MIN(temperature) AS min_temp,
         COUNT(*) AS readings
  FROM metrics
  WHERE time > NOW() - INTERVAL '24 hours'
  GROUP BY bucket, device_id
  ORDER BY bucket DESC;

  -- time_bucket_gapfill (fill missing intervals)
  SELECT time_bucket_gapfill('1 hour', time) AS bucket,
         device_id,
         COALESCE(AVG(temperature), locf(AVG(temperature))) AS temp
  FROM metrics
  WHERE time > NOW() - INTERVAL '7 days'
  GROUP BY bucket, device_id;
  -- locf = Last Observation Carried Forward
  -- interpolate() = linear interpolation

  -- First/last value
  SELECT device_id,
         first(temperature, time) AS first_reading,
         last(temperature, time) AS latest_reading
  FROM metrics
  WHERE time > NOW() - INTERVAL '1 hour'
  GROUP BY device_id;

  -- Delta (change over time)
  SELECT time_bucket('1 hour', time) AS bucket,
         device_id,
         last(cpu_usage, time) - first(cpu_usage, time) AS cpu_delta
  FROM metrics
  GROUP BY bucket, device_id;

  -- Percentiles
  SELECT time_bucket('1 hour', time) AS bucket,
         percentile_agg(temperature) AS pct_agg,
         approx_percentile(0.50, percentile_agg(temperature)) AS p50,
         approx_percentile(0.95, percentile_agg(temperature)) AS p95,
         approx_percentile(0.99, percentile_agg(temperature)) AS p99
  FROM metrics
  GROUP BY bucket;
EOF
}

cmd_advanced() {
cat << 'EOF'
COMPRESSION, AGGREGATION & RETENTION
========================================

CONTINUOUS AGGREGATES (auto-refreshing materialized views):
  CREATE MATERIALIZED VIEW hourly_metrics
  WITH (timescaledb.continuous) AS
  SELECT time_bucket('1 hour', time) AS bucket,
         device_id,
         AVG(temperature) AS avg_temp,
         MAX(temperature) AS max_temp,
         MIN(temperature) AS min_temp,
         COUNT(*) AS readings
  FROM metrics
  GROUP BY bucket, device_id
  WITH NO DATA;

  -- Refresh policy (auto-update)
  SELECT add_continuous_aggregate_policy('hourly_metrics',
      start_offset => INTERVAL '3 days',
      end_offset   => INTERVAL '1 hour',
      schedule_interval => INTERVAL '1 hour');

  -- Real-time aggregation (combines materialized + recent)
  ALTER MATERIALIZED VIEW hourly_metrics
  SET (timescaledb.materialized_only = false);

  -- Query just like a table
  SELECT * FROM hourly_metrics
  WHERE bucket > NOW() - INTERVAL '7 days'
  ORDER BY bucket DESC;

  -- Hierarchical aggregates (agg of agg)
  CREATE MATERIALIZED VIEW daily_metrics
  WITH (timescaledb.continuous) AS
  SELECT time_bucket('1 day', bucket) AS day,
         device_id,
         AVG(avg_temp) AS avg_temp
  FROM hourly_metrics
  GROUP BY day, device_id;

COMPRESSION:
  -- Enable compression
  ALTER TABLE metrics SET (
      timescaledb.compress,
      timescaledb.compress_segmentby = 'device_id',
      timescaledb.compress_orderby = 'time DESC'
  );

  -- Compression policy (auto-compress old chunks)
  SELECT add_compression_policy('metrics', INTERVAL '7 days');

  -- Manual compress
  SELECT compress_chunk(c) FROM show_chunks('metrics',
      older_than => INTERVAL '7 days') c;

  -- Check compression ratio
  SELECT pg_size_pretty(before_compression_total_bytes) AS before,
         pg_size_pretty(after_compression_total_bytes) AS after,
         pg_size_pretty(before_compression_total_bytes -
                        after_compression_total_bytes) AS saved
  FROM hypertable_compression_stats('metrics');

RETENTION (auto-drop old data):
  SELECT add_retention_policy('metrics', INTERVAL '90 days');
  -- Automatically drops chunks older than 90 days

  -- Manual drop
  SELECT drop_chunks('metrics', older_than => INTERVAL '30 days');

MONITORING:
  -- Chunk info
  SELECT * FROM timescaledb_information.chunks
  WHERE hypertable_name = 'metrics'
  ORDER BY range_start DESC LIMIT 10;

  -- Job stats
  SELECT * FROM timescaledb_information.jobs;
  SELECT * FROM timescaledb_information.job_stats;

  -- Hypertable size
  SELECT hypertable_name,
         pg_size_pretty(hypertable_size(format('%I.%I', hypertable_schema, hypertable_name)::regclass))
  FROM timescaledb_information.hypertables;

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
TimescaleDB - Time-Series Database Reference

Commands:
  intro      Overview, comparison
  tables     Hypertables, time-series queries, gapfill
  advanced   Compression, continuous aggs, retention

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  tables)   cmd_tables ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
