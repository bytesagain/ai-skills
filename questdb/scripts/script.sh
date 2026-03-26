#!/bin/bash
# QuestDB - High-Performance Time-Series Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              QUESTDB REFERENCE                              ║
║          Blazing-Fast Time-Series Database                  ║
╚══════════════════════════════════════════════════════════════╝

QuestDB is a high-performance time-series database written in
Java and C++. It can ingest millions of rows per second on a
single machine using memory-mapped files.

KEY FEATURES:
  Speed            1.4M rows/sec ingestion on commodity HW
  SQL              Extended SQL with time-series functions
  ILP              InfluxDB Line Protocol for ingestion
  Column-oriented  Columnar storage with SIMD acceleration
  Memory-mapped    Zero-copy reads via mmap
  Web console      Built-in SQL editor at port 9000
  PostgreSQL wire  Connect with any PG client
  Deduplication    Built-in dedup on ingestion

QUESTDB vs TIMESCALEDB vs INFLUXDB:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ QuestDB  │Timescale │ InfluxDB │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Ingestion    │ 1.4M/s   │ 300K/s   │ 500K/s   │
  │ Query lang   │ SQL+ext  │ SQL      │ Flux/SQL │
  │ JOINs        │ Yes      │ Yes      │ Limited  │
  │ Storage      │ Columnar │ Row(PG)  │ Custom   │
  │ Compression  │ Partial  │ Native   │ Native   │
  │ License      │ Apache2  │ Apache2  │ MIT/Prop │
  │ Written in   │ Java/C++ │ C(PG)    │ Go/Rust  │
  │ Best for     │ High-freq│ General  │ Metrics  │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Docker
  docker run -p 9000:9000 -p 9009:9009 -p 8812:8812 \
    questdb/questdb

  # Ports: 9000=Web Console, 9009=ILP, 8812=PostgreSQL wire
EOF
}

cmd_queries() {
cat << 'EOF'
SQL & TIME-SERIES FUNCTIONS
==============================

CREATE TABLE:
  CREATE TABLE trades (
      symbol SYMBOL CAPACITY 256 INDEX,
      price DOUBLE,
      volume LONG,
      timestamp TIMESTAMP
  ) TIMESTAMP(timestamp) PARTITION BY DAY WAL
  DEDUP UPSERT KEYS(timestamp, symbol);

  -- SYMBOL type: dictionary-encoded string (fast filtering)
  -- TIMESTAMP column: designated timestamp for time-series ops
  -- PARTITION BY: DAY/MONTH/YEAR/HOUR
  -- WAL: Write-Ahead Log for crash recovery
  -- DEDUP: automatic deduplication

INGESTION (InfluxDB Line Protocol):
  # TCP socket (port 9009)
  echo "trades,symbol=AAPL price=185.42,volume=1000 1679529600000000000" | \
    nc localhost 9009

  # Python
  from questdb.ingress import Sender, IngressError
  with Sender('localhost', 9009) as sender:
      sender.row('trades',
          symbols={'symbol': 'AAPL'},
          columns={'price': 185.42, 'volume': 1000},
          at=datetime.now())
      sender.flush()

SAMPLE BY (time bucketing):
  -- OHLCV candles
  SELECT timestamp, symbol,
      first(price) AS open,
      max(price) AS high,
      min(price) AS low,
      last(price) AS close,
      sum(volume) AS volume
  FROM trades
  WHERE symbol = 'AAPL'
      AND timestamp IN '2026-03'
  SAMPLE BY 1h;

  -- With fill
  SAMPLE BY 1h FILL(PREV);    -- Carry forward
  SAMPLE BY 1h FILL(LINEAR);  -- Interpolate
  SAMPLE BY 1h FILL(NULL);    -- NULL for gaps
  SAMPLE BY 1h FILL(0);       -- Zero for gaps

LATEST ON (last value per key):
  -- Get latest reading per device
  SELECT * FROM sensors
  LATEST ON timestamp PARTITION BY device_id;
  -- Extremely fast — special index, no GROUP BY needed

ASOF JOIN (time-series join):
  -- Match trades to closest quote
  SELECT t.timestamp, t.symbol, t.price, q.bid, q.ask
  FROM trades t
  ASOF JOIN quotes q ON (t.symbol = q.symbol);
  -- Joins on closest timestamp <= trade timestamp

  -- SPLICE JOIN (interleave two time series)
  SELECT * FROM series_a
  SPLICE JOIN series_b;

LT/BETWEEN TIMESTAMP:
  -- Interval syntax
  WHERE timestamp IN '2026-03-24'              -- Whole day
  WHERE timestamp IN '2026-03'                 -- Whole month
  WHERE timestamp IN '2026'                    -- Whole year
  WHERE timestamp BETWEEN '2026-03-24' AND '2026-03-25'
  WHERE timestamp > dateadd('h', -1, now())    -- Last hour

WHERE IN (designated timestamp):
  -- Fast partition pruning
  WHERE timestamp IN '2026-03-24T10:00:00;5m'  -- 5 min window
  WHERE timestamp IN '2026-03-24;1h'           -- 1 hour window
EOF
}

cmd_admin() {
cat << 'EOF'
ADMIN & CLIENTS
=================

WEB CONSOLE (port 9000):
  http://localhost:9000
  -- Built-in SQL editor with auto-complete
  -- Chart visualization
  -- Import CSV via drag-and-drop

POSTGRESQL WIRE (port 8812):
  psql -h localhost -p 8812 -U admin -d qdb
  # Default: user=admin, password=quest, db=qdb

  # Python (psycopg2)
  import psycopg2
  conn = psycopg2.connect(host='localhost', port=8812,
                          user='admin', password='quest', dbname='qdb')

  # Any PostgreSQL client works

REST API (port 9000):
  # Query
  curl "http://localhost:9000/exec?query=SELECT+*+FROM+trades+LIMIT+10"

  # CSV export
  curl "http://localhost:9000/exp?query=SELECT+*+FROM+trades" > data.csv

  # Import CSV
  curl -F data=@trades.csv "http://localhost:9000/imp?name=trades"

CONFIGURATION (server.conf):
  # Partitions
  cairo.sql.partition.type=DAY

  # Memory
  cairo.writer.memory.limit=4g

  # Parallel query
  cairo.page.frame.shard.count=4

  # Retention
  # No built-in policy — use scheduled DROP PARTITION

MAINTENANCE:
  -- Table info
  SELECT * FROM tables();
  SELECT * FROM table_columns('trades');
  SELECT * FROM table_partitions('trades');

  -- Partition management
  ALTER TABLE trades DROP PARTITION LIST '2026-01', '2026-02';
  ALTER TABLE trades DETACH PARTITION LIST '2026-01';  -- Archive
  ALTER TABLE trades ATTACH PARTITION LIST '2026-01';  -- Restore

  -- Vacuum
  VACUUM TABLE trades;

  -- Update (limited — column-level only)
  UPDATE trades SET price = 0 WHERE symbol = 'DELISTED';

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
QuestDB - High-Performance Time-Series Database Reference

Commands:
  intro    Overview, comparison, install
  queries  SQL, SAMPLE BY, LATEST ON, ASOF JOIN
  admin    Web console, PG wire, REST API, partitions

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  queries) cmd_queries ;;
  admin)   cmd_admin ;;
  help|*)  show_help ;;
esac
