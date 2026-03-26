#!/bin/bash
# CockroachDB - Distributed SQL Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              COCKROACHDB REFERENCE                          ║
║          Distributed SQL That Survives Anything             ║
╚══════════════════════════════════════════════════════════════╝

CockroachDB is a distributed SQL database that provides:
- PostgreSQL-compatible SQL
- Serializable ACID transactions
- Multi-region, multi-cloud deployment
- Automatic sharding and rebalancing
- Survives datacenter failures without data loss

ARCHITECTURE:
  Every node is equal (no master).
  Data is split into ranges (~512MB each).
  Each range replicated across 3+ nodes via Raft consensus.
  Leaseholder handles reads/writes for each range.

  App → Any CockroachDB Node → Routes to Leaseholder → Raft → Commit

KEY CONCEPTS:
  Range        Unit of data (sorted key span, ~512MB)
  Leaseholder  Node that serves reads for a range
  Raft         Consensus protocol for replication
  Gateway      Node that receives client connection
  Locality     Region/zone/rack labeling for data placement

CockroachDB vs PostgreSQL vs Spanner:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ CockroachDB│Postgres│ Spanner  │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Distributed  │ Yes      │ No*      │ Yes      │
  │ SQL          │ Postgres │ Postgres │ Custom   │
  │ Auto-shard   │ Yes      │ No       │ Yes      │
  │ Multi-region │ Yes      │ Manual   │ Yes      │
  │ Consistency  │ Serial.  │ Serial.  │ External │
  │ Self-hosted  │ Yes      │ Yes      │ No       │
  │ License      │ BSL/MIT  │ Open     │ Proprietary│
  └──────────────┴──────────┴──────────┴──────────┘
  * Citus/Patroni add some distribution
EOF
}

cmd_sql() {
cat << 'EOF'
SQL (PostgreSQL-Compatible)
=============================

CockroachDB speaks PostgreSQL wire protocol.
Most pg tools, ORMs, and drivers work unchanged.

CREATE TABLE:
  CREATE TABLE users (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      email STRING UNIQUE NOT NULL,
      name STRING NOT NULL,
      balance DECIMAL(10,2) DEFAULT 0,
      created_at TIMESTAMPTZ DEFAULT now(),
      region STRING NOT NULL,
      INDEX idx_email (email),
      INDEX idx_region_created (region, created_at DESC)
  );

  -- Hash-sharded index (spread writes across ranges)
  CREATE TABLE events (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      ts TIMESTAMPTZ DEFAULT now(),
      data JSONB,
      INDEX idx_ts (ts) USING HASH
  );

INSERT:
  INSERT INTO users (email, name, region)
  VALUES ('alice@example.com', 'Alice', 'us-east')
  RETURNING id;

  -- Upsert
  UPSERT INTO users (email, name, region)
  VALUES ('alice@example.com', 'Alice Updated', 'us-east');

  -- On conflict
  INSERT INTO users (email, name, region)
  VALUES ('alice@example.com', 'Alice', 'us-east')
  ON CONFLICT (email) DO UPDATE SET name = excluded.name;

SELECT:
  SELECT * FROM users WHERE region = 'us-east' ORDER BY created_at DESC LIMIT 20;

  -- JSONB queries
  SELECT * FROM events WHERE data->>'type' = 'purchase';
  SELECT * FROM events WHERE data @> '{"status": "active"}';

TRANSACTIONS:
  BEGIN;
  UPDATE users SET balance = balance - 100 WHERE id = $1;
  UPDATE users SET balance = balance + 100 WHERE id = $2;
  COMMIT;

  -- Serializable by default (strongest isolation!)
  -- Automatic retry on contention

  -- SELECT FOR UPDATE (pessimistic locking)
  BEGIN;
  SELECT * FROM inventory WHERE product_id = 1 FOR UPDATE;
  UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 1;
  COMMIT;

COMMON TABLE EXPRESSIONS:
  WITH monthly AS (
      SELECT date_trunc('month', created_at) AS month,
             count(*) AS signups
      FROM users
      GROUP BY 1
  )
  SELECT month, signups,
         sum(signups) OVER (ORDER BY month) AS cumulative
  FROM monthly;

COMPUTED COLUMNS:
  ALTER TABLE users ADD COLUMN email_domain STRING
      AS (split_part(email, '@', 2)) STORED;
EOF
}

cmd_multiregion() {
cat << 'EOF'
MULTI-REGION
==============

CockroachDB's killer feature: survive regional outages.

SETUP REGIONS:
  ALTER DATABASE mydb PRIMARY REGION "us-east1";
  ALTER DATABASE mydb ADD REGION "us-west2";
  ALTER DATABASE mydb ADD REGION "eu-west1";

SURVIVAL GOALS:
  -- Survive zone failure (default)
  ALTER DATABASE mydb SURVIVE ZONE FAILURE;

  -- Survive entire region failure (need 3+ regions)
  ALTER DATABASE mydb SURVIVE REGION FAILURE;

TABLE LOCALITY:

  REGIONAL BY TABLE (default):
    All data in primary region. Fast reads/writes in that region.
    CREATE TABLE config (k STRING PRIMARY KEY, v STRING)
    LOCALITY REGIONAL BY TABLE IN PRIMARY REGION;

  REGIONAL BY ROW:
    Each row lives in its specified region. Users get local latency.
    CREATE TABLE user_profiles (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        region crdb_internal_region NOT NULL DEFAULT gateway_region()::crdb_internal_region,
        name STRING,
        data JSONB
    ) LOCALITY REGIONAL BY ROW;

    -- Queries filtered by region are fast (reads local data)
    SELECT * FROM user_profiles WHERE region = 'us-east1';

  GLOBAL:
    Replicated everywhere, reads from any region are fast.
    Writes are slower (cross-region consensus).
    CREATE TABLE countries (code STRING PRIMARY KEY, name STRING)
    LOCALITY GLOBAL;
    -- Perfect for: reference data, config, feature flags

LATENCY COMPARISON (3 regions):
  ┌─────────────────────┬────────────┬──────────────┐
  │ Locality            │ Local Read │ Write        │
  ├─────────────────────┼────────────┼──────────────┤
  │ REGIONAL BY TABLE   │ ~2ms       │ ~2ms         │
  │ REGIONAL BY ROW     │ ~2ms       │ ~2ms (local) │
  │ GLOBAL              │ ~2ms       │ ~100-200ms   │
  │ REGIONAL (non-local)│ ~80ms      │ ~80ms        │
  └─────────────────────┴────────────┴──────────────┘
EOF
}

cmd_operations() {
cat << 'EOF'
OPERATIONS
============

INSTALL:
  # Binary
  curl https://binaries.cockroachdb.com/cockroach-latest.linux-amd64.tgz | tar xz
  sudo cp cockroach-*/cockroach /usr/local/bin/

  # Docker
  docker run -d --name crdb -p 26257:26257 -p 8080:8080 cockroachdb/cockroach start-single-node --insecure

  # Kubernetes (operator)
  kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/install/operator.yaml

START CLUSTER:
  # Node 1
  cockroach start --insecure --store=node1 --listen-addr=:26257 \
    --http-addr=:8080 --join=node1:26257,node2:26257,node3:26257

  # Node 2
  cockroach start --insecure --store=node2 --listen-addr=:26258 \
    --http-addr=:8081 --join=node1:26257,node2:26257,node3:26257

  # Initialize
  cockroach init --insecure --host=localhost:26257

CLI:
  cockroach sql --insecure
  cockroach sql --insecure -e "SELECT count(*) FROM users"
  cockroach node status --insecure
  cockroach node decommission 4 --insecure  # Remove node

MONITORING (DB Console: http://localhost:8080):
  -- Cluster health
  SELECT node_id, address, is_available, is_live FROM crdb_internal.gossip_nodes;

  -- Range info
  SELECT count(*) AS ranges FROM crdb_internal.ranges;

  -- Slow queries
  SELECT * FROM crdb_internal.node_statement_statistics
  ORDER BY service_lat_avg DESC LIMIT 10;

  -- Table sizes
  SELECT table_name, pg_size_pretty(crdb_internal.table_span_stats(table_id)->'approximate_disk_bytes')
  FROM crdb_internal.tables WHERE database_name = current_database();

BACKUP:
  -- Full backup to cloud
  BACKUP DATABASE mydb TO 's3://bucket/backup?AUTH=implicit';

  -- Incremental
  BACKUP DATABASE mydb TO 's3://bucket/backup/inc'
  INCREMENTAL FROM 's3://bucket/backup/full';

  -- Scheduled
  CREATE SCHEDULE daily_backup FOR BACKUP DATABASE mydb
  INTO 's3://bucket/backups' RECURRING '@daily'
  WITH SCHEDULE OPTIONS first_run = 'now';

  -- Restore
  RESTORE DATABASE mydb FROM 's3://bucket/backup';

CONNECTION STRING:
  postgresql://user:pass@host:26257/mydb?sslmode=require
  # Works with any PostgreSQL driver!

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
CockroachDB - Distributed SQL Database Reference

Commands:
  intro        Overview, architecture, comparison
  sql          PostgreSQL-compatible queries, transactions
  multiregion  Multi-region setup, locality, survival goals
  operations   Install, cluster, monitoring, backup

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  sql)         cmd_sql ;;
  multiregion) cmd_multiregion ;;
  operations)  cmd_operations ;;
  help|*)      show_help ;;
esac
