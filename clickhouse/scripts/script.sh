#!/bin/bash
# ClickHouse - OLAP Column-Store Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CLICKHOUSE REFERENCE                           ║
║          Fastest Open-Source OLAP Database                   ║
╚══════════════════════════════════════════════════════════════╝

ClickHouse is a column-oriented OLAP database for real-time
analytics. It processes billions of rows per second on commodity
hardware.

KEY FEATURES:
  Column-store     Only reads columns needed for query
  Vectorized       SIMD-optimized batch processing
  Compression      LZ4/ZSTD, 10-40x compression ratios
  Real-time        Sub-second queries on billions of rows
  SQL              Full SQL with extensions
  Distributed      Sharding + replication across clusters
  Materialized     Pre-aggregated views for instant dashboards

WHO USES IT:
  Cloudflare (HTTP analytics), Uber, eBay, Spotify, GitLab,
  Deutsche Bank — for log analytics, event tracking, BI.

CLICKHOUSE vs ALTERNATIVES:
  ┌──────────────┬────────────┬──────────┬──────────┐
  │ Feature      │ ClickHouse │ BigQuery │ Druid    │
  ├──────────────┼────────────┼──────────┼──────────┤
  │ Model        │ Column     │ Column   │ Column   │
  │ Self-hosted  │ Yes        │ No       │ Yes      │
  │ Latency      │ ~50ms      │ ~2s      │ ~200ms   │
  │ Compression  │ Best       │ Good     │ Good     │
  │ Joins        │ Yes        │ Yes      │ Limited  │
  │ Updates      │ Async      │ Yes      │ No       │
  │ Cost         │ Free       │ Pay/query│ Free     │
  │ Ecosystem    │ Growing    │ GCP      │ Apache   │
  └──────────────┴────────────┴──────────┴──────────┘

WHEN TO USE:
  ✓ Analytics, dashboards, reporting
  ✓ Log storage and analysis
  ✓ Time-series aggregations
  ✓ Event tracking (clicks, pageviews)
  ✓ Ad-hoc exploration of large datasets

WHEN NOT TO USE:
  ✗ OLTP (frequent small updates/deletes)
  ✗ Key-value lookups
  ✗ Transactions requiring ACID
  ✗ Blob/document storage
EOF
}

cmd_sql() {
cat << 'EOF'
SQL QUERIES
=============

CREATE TABLE:
  CREATE TABLE events (
      event_date Date,
      event_time DateTime,
      user_id UInt64,
      event_type String,
      page String,
      duration Float32,
      country LowCardinality(String)
  )
  ENGINE = MergeTree()
  PARTITION BY toYYYYMM(event_date)
  ORDER BY (event_type, user_id, event_time)
  TTL event_date + INTERVAL 90 DAY;

  -- ORDER BY is critical: defines sort order for fast range queries
  -- PARTITION BY: data physically split (usually by month)
  -- TTL: auto-delete old data

INSERT:
  INSERT INTO events VALUES
      ('2026-03-24', '2026-03-24 10:30:00', 12345, 'pageview', '/home', 2.5, 'US'),
      ('2026-03-24', '2026-03-24 10:31:00', 12346, 'click', '/buy', 0.8, 'DE');

  -- Batch insert (much faster than row-by-row)
  INSERT INTO events FORMAT JSONEachRow
  {"event_date":"2026-03-24","event_time":"2026-03-24 10:30:00","user_id":12345}

  -- From file
  cat data.csv | clickhouse-client --query="INSERT INTO events FORMAT CSV"

ANALYTICS QUERIES:
  -- Events per day
  SELECT event_date, count() AS events
  FROM events
  GROUP BY event_date
  ORDER BY event_date DESC
  LIMIT 30;

  -- Top pages this week
  SELECT page, uniq(user_id) AS unique_users, count() AS views
  FROM events
  WHERE event_date >= today() - 7
  GROUP BY page
  ORDER BY unique_users DESC
  LIMIT 20;

  -- Funnel analysis
  SELECT
      countIf(event_type = 'pageview') AS step1_view,
      countIf(event_type = 'add_to_cart') AS step2_cart,
      countIf(event_type = 'purchase') AS step3_buy,
      round(step3_buy / step1_view * 100, 2) AS conversion_rate
  FROM events
  WHERE event_date = today();

  -- Percentiles
  SELECT
      quantile(0.50)(duration) AS p50,
      quantile(0.95)(duration) AS p95,
      quantile(0.99)(duration) AS p99
  FROM events
  WHERE event_type = 'pageview';

  -- Window functions
  SELECT user_id, event_time, page,
      row_number() OVER (PARTITION BY user_id ORDER BY event_time) AS visit_order,
      lagInFrame(page) OVER (PARTITION BY user_id ORDER BY event_time) AS prev_page
  FROM events;

DATA TYPES:
  UInt8/16/32/64/128/256   Unsigned integers
  Int8/16/32/64/128/256    Signed integers
  Float32/Float64          IEEE 754
  Decimal(P, S)            Fixed precision
  String                   Variable length
  FixedString(N)           Fixed length
  Date / Date32            Day precision
  DateTime / DateTime64    Second/sub-second
  UUID                     UUID v4
  Array(T)                 [1, 2, 3]
  Tuple(T1, T2)            Named or positional
  Map(K, V)                Key-value pairs
  Nullable(T)              Allows NULL (adds overhead)
  LowCardinality(T)        Dictionary encoding (< 10K unique values)
  Enum8/Enum16             Enumerated values
EOF
}

cmd_engines() {
cat << 'EOF'
TABLE ENGINES
===============

MergeTree (most important):
  ENGINE = MergeTree()
  ORDER BY (col1, col2)

  The default engine. Supports:
  - Columnar storage with compression
  - Primary key index (sparse, ~8192 rows/granule)
  - Partitioning (by month, day, etc.)
  - TTL for automatic data expiration
  - Data sampling

REPLICATED:
  ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/events', '{replica}')
  ORDER BY (event_type, user_id)

  -- Replication via ZooKeeper/ClickHouse Keeper
  -- Automatic failover

REPLACING MERGE TREE:
  ENGINE = ReplacingMergeTree(version_column)
  ORDER BY (id)

  -- Deduplicates by ORDER BY key
  -- Keeps row with highest version
  -- Dedup happens during merges (eventual, not immediate)

  SELECT * FROM events FINAL;  -- Force deduplicated read

AGGREGATING MERGE TREE:
  ENGINE = AggregatingMergeTree()
  ORDER BY (key)

  -- Stores pre-aggregated states
  -- Used with materialized views for real-time rollups

SUMMING MERGE TREE:
  ENGINE = SummingMergeTree((metric1, metric2))
  ORDER BY (key)

  -- Automatically sums numeric columns on merge

MATERIALIZED VIEWS:
  -- Real-time aggregation pipeline
  CREATE MATERIALIZED VIEW hourly_stats
  ENGINE = SummingMergeTree()
  ORDER BY (hour, event_type)
  AS SELECT
      toStartOfHour(event_time) AS hour,
      event_type,
      count() AS events,
      uniq(user_id) AS users
  FROM events
  GROUP BY hour, event_type;

  -- Automatically populated on INSERT to events table

DISTRIBUTED:
  -- Query across shards
  CREATE TABLE events_distributed AS events
  ENGINE = Distributed(cluster_name, database, events, rand());

OTHER ENGINES:
  Log              Append-only, no indexes (small tables)
  Memory           In-RAM, lost on restart
  Buffer           Buffer inserts, flush to target table
  Kafka            Read from Kafka topics
  S3               Query S3/GCS directly
  URL              Query remote HTTP endpoints
  Dictionary       In-memory lookup tables
  MaterializedView Auto-maintained aggregations
EOF
}

cmd_operations() {
cat << 'EOF'
OPERATIONS
============

INSTALL:
  # Ubuntu/Debian
  curl https://clickhouse.com/ | sh
  sudo ./clickhouse install
  sudo clickhouse start

  # Docker
  docker run -d --name ch -p 8123:8123 -p 9000:9000 clickhouse/clickhouse-server

CLI:
  clickhouse-client                          # Interactive
  clickhouse-client --query "SELECT 1"       # One-shot
  clickhouse-client --format Pretty          # Formatted output
  clickhouse-client -h remote-host -u user --password pass

HTTP API:
  curl 'http://localhost:8123/?query=SELECT+1'
  curl 'http://localhost:8123/' --data-binary 'SELECT count() FROM events'
  echo 'SELECT 1 FORMAT JSON' | curl 'http://localhost:8123/' --data-binary @-

MONITORING:
  SELECT * FROM system.metrics;              # Current metrics
  SELECT * FROM system.events;               # Cumulative counters
  SELECT * FROM system.parts;                # Table parts info
  SELECT * FROM system.merges;               # Active merges
  SELECT * FROM system.query_log ORDER BY event_time DESC LIMIT 10;
  SELECT * FROM system.processes;            # Running queries

  -- Disk usage per table
  SELECT table, formatReadableSize(sum(bytes)) AS size,
         sum(rows) AS rows, count() AS parts
  FROM system.parts
  WHERE active
  GROUP BY table
  ORDER BY sum(bytes) DESC;

OPTIMIZATION:
  -- Force merge (careful with large tables)
  OPTIMIZE TABLE events FINAL;

  -- Mutation (async update/delete)
  ALTER TABLE events DELETE WHERE user_id = 0;
  ALTER TABLE events UPDATE country = 'UK' WHERE country = 'GB';

  -- Check mutation progress
  SELECT * FROM system.mutations WHERE is_done = 0;

BACKUP:
  -- Built-in backup (ClickHouse 22.8+)
  BACKUP TABLE events TO Disk('backups', 'events_20260324.zip');
  RESTORE TABLE events FROM Disk('backups', 'events_20260324.zip');

  -- clickhouse-backup tool (popular third-party)
  clickhouse-backup create daily_backup
  clickhouse-backup upload daily_backup

PERFORMANCE TIPS:
  1. ORDER BY matches your most common WHERE/GROUP BY filters
  2. Use LowCardinality for columns with < 10K unique values
  3. Avoid Nullable unless truly needed (adds 1 byte per value)
  4. Batch inserts (1000+ rows per INSERT)
  5. Use materialized views for real-time aggregation
  6. Partition by month (too many partitions = slow)
  7. Use PREWHERE instead of WHERE for better column pruning
  8. Use sampling for approximate queries on huge datasets

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
ClickHouse - OLAP Column-Store Database Reference

Commands:
  intro       Overview, comparison, use cases
  sql         Queries, analytics, data types
  engines     MergeTree, replication, materialized views
  operations  Install, CLI, HTTP, monitoring, backup

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  sql)        cmd_sql ;;
  engines)    cmd_engines ;;
  operations) cmd_operations ;;
  help|*)     show_help ;;
esac
