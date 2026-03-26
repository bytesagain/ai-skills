#!/bin/bash
# Apache Cassandra - Distributed NoSQL Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CASSANDRA REFERENCE                            ║
║          Distributed Wide-Column NoSQL Database             ║
╚══════════════════════════════════════════════════════════════╝

Apache Cassandra is a distributed NoSQL database designed for
handling large amounts of data across many commodity servers
with no single point of failure.

KEY FEATURES:
  Distributed    Data spread across multiple nodes
  Masterless     No single point of failure (peer-to-peer)
  Linearly scalable  Add nodes = more capacity, linearly
  Tunable consistency  Choose per-query: strong or eventual
  Write-optimized  Extremely fast writes (append-only)
  Wide-column    Flexible schema within column families
  Multi-DC       Built-in multi-datacenter replication

WHO USES IT:
  Netflix (streaming metadata), Apple (10K+ nodes), Discord,
  Instagram, Uber, eBay, Spotify — for massive scale workloads.

CASSANDRA vs ALTERNATIVES:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │Cassandra │ MongoDB  │ DynamoDB │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Model        │ Wide-col │ Document │ Key-value│
  │ Masterless   │ Yes      │ No       │ Managed  │
  │ Write speed  │ Fastest  │ Fast     │ Fast     │
  │ Read pattern │ Key-based│ Flexible │ Key-based│
  │ Consistency  │ Tunable  │ Tunable  │ Tunable  │
  │ Multi-DC     │ Native   │ Atlas    │ Global   │
  │ Operations   │ Complex  │ Medium   │ None     │
  │ Joins        │ No       │ $lookup  │ No       │
  │ Cost at scale│ Low      │ Medium   │ High     │
  └──────────────┴──────────┴──────────┴──────────┘

ARCHITECTURE:
  All nodes are equal (peer-to-peer ring).
  Data is partitioned by partition key (hash).
  Each partition is replicated to N nodes (replication factor).

  ┌─────┐  ┌─────┐  ┌─────┐
  │Node1│──│Node2│──│Node3│
  │ A,D │  │ B,E │  │ C,F │
  └──┬──┘  └──┬──┘  └──┬──┘
     │        │        │
  ┌──┴──┐  ┌──┴──┐  ┌──┴──┐
  │Node4│──│Node5│──│Node6│
  │ D,A │  │ E,B │  │ F,C │  (replicas)
  └─────┘  └─────┘  └─────┘
EOF
}

cmd_cql() {
cat << 'EOF'
CQL (Cassandra Query Language)
================================

CQL looks like SQL but with important differences.

KEYSPACE (= database):
  CREATE KEYSPACE myapp
    WITH replication = {
      'class': 'NetworkTopologyStrategy',
      'dc1': 3,
      'dc2': 3
    };

  USE myapp;

  -- SimpleStrategy for single DC:
  CREATE KEYSPACE dev
    WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

TABLES:
  CREATE TABLE users (
      user_id UUID PRIMARY KEY,
      username TEXT,
      email TEXT,
      created_at TIMESTAMP
  );

  -- Compound primary key (partition key + clustering columns)
  CREATE TABLE messages (
      channel_id UUID,
      sent_at TIMESTAMP,
      user_id UUID,
      content TEXT,
      PRIMARY KEY (channel_id, sent_at)
  ) WITH CLUSTERING ORDER BY (sent_at DESC);

  -- Composite partition key
  CREATE TABLE sensor_data (
      sensor_id TEXT,
      date DATE,
      timestamp TIMESTAMP,
      value DOUBLE,
      PRIMARY KEY ((sensor_id, date), timestamp)
  );

INSERT:
  INSERT INTO users (user_id, username, email, created_at)
    VALUES (uuid(), 'alice', 'alice@example.com', toTimestamp(now()));

  -- With TTL (auto-delete after 86400 seconds)
  INSERT INTO messages (channel_id, sent_at, user_id, content)
    VALUES (?, now(), ?, 'Hello!')
    USING TTL 86400;

SELECT:
  SELECT * FROM users WHERE user_id = ?;

  -- Range query on clustering column
  SELECT * FROM messages
    WHERE channel_id = ?
    AND sent_at > '2026-03-01'
    ORDER BY sent_at DESC
    LIMIT 50;

  -- ALLOW FILTERING (use sparingly!)
  SELECT * FROM users WHERE email = 'alice@example.com'
    ALLOW FILTERING;

UPDATE:
  UPDATE users SET email = 'newemail@example.com'
    WHERE user_id = ?;

DELETE:
  DELETE FROM users WHERE user_id = ?;
  DELETE FROM messages WHERE channel_id = ? AND sent_at = ?;

BATCH (use carefully):
  BEGIN BATCH
    INSERT INTO users (user_id, username) VALUES (?, 'alice');
    INSERT INTO user_emails (email, user_id) VALUES ('alice@example.com', ?);
  APPLY BATCH;
  -- Only for maintaining consistency across denormalized tables
  -- NOT for bulk loading!

DATA TYPES:
  TEXT/VARCHAR   UTF-8 string
  INT            32-bit integer
  BIGINT         64-bit integer
  FLOAT/DOUBLE   Floating point
  BOOLEAN        true/false
  UUID           UUID v4
  TIMEUUID       UUID v1 (time-based)
  TIMESTAMP      Date and time
  DATE           Date only
  BLOB           Binary data
  LIST<T>        Ordered collection
  SET<T>         Unique collection
  MAP<K,V>       Key-value pairs
  FROZEN<T>      Immutable complex type
  COUNTER        Distributed counter
EOF
}

cmd_modeling() {
cat << 'EOF'
DATA MODELING
===============

GOLDEN RULE:
  Model your tables around your queries, NOT your entities.
  Denormalization is expected and necessary.

PARTITION KEY DESIGN:
  The partition key determines which node stores the data.

  Good partition keys:
  ✓ High cardinality (many unique values)
  ✓ Even distribution (avoid hot partitions)
  ✓ Used in every query's WHERE clause

  Bad partition keys:
  ✗ Low cardinality (country, status — creates hot partitions)
  ✗ Monotonically increasing (timestamp alone — all writes to one node)

QUERY-DRIVEN DESIGN EXAMPLE:
  Requirements:
  Q1: Get user by ID
  Q2: Get user's posts (newest first)
  Q3: Get posts by tag (newest first)
  Q4: Get post by ID

  Tables:
  -- Q1
  CREATE TABLE users (
      user_id UUID PRIMARY KEY,
      username TEXT, bio TEXT
  );

  -- Q2
  CREATE TABLE posts_by_user (
      user_id UUID,
      post_id TIMEUUID,
      title TEXT, content TEXT,
      PRIMARY KEY (user_id, post_id)
  ) WITH CLUSTERING ORDER BY (post_id DESC);

  -- Q3
  CREATE TABLE posts_by_tag (
      tag TEXT,
      post_id TIMEUUID,
      title TEXT, user_id UUID,
      PRIMARY KEY (tag, post_id)
  ) WITH CLUSTERING ORDER BY (post_id DESC);

  -- Q4
  CREATE TABLE posts (
      post_id TIMEUUID PRIMARY KEY,
      title TEXT, content TEXT, user_id UUID
  );

  Same data, 4 tables. Each optimized for one query.

PARTITION SIZE LIMITS:
  Recommended: < 100MB per partition, < 100K rows
  Monitor with: nodetool tablehistograms

  If partitions grow too large, add a bucketing column:
  PRIMARY KEY ((sensor_id, date), timestamp)
  -- Partitions bounded by day

SECONDARY INDEXES:
  CREATE INDEX ON users (email);
  -- Use sparingly! Scans all nodes.
  -- Better: create a denormalized lookup table.

MATERIALIZED VIEWS:
  CREATE MATERIALIZED VIEW users_by_email AS
    SELECT * FROM users
    WHERE email IS NOT NULL
    PRIMARY KEY (email, user_id);
  -- Automatically maintained by Cassandra
  -- Still has limitations and consistency caveats
EOF
}

cmd_operations() {
cat << 'EOF'
OPERATIONS & ADMINISTRATION
==============================

NODETOOL (CLI):
  nodetool status              # Cluster status (UN = Up Normal)
  nodetool info                # Node details
  nodetool ring                # Token ring
  nodetool tablestats myapp    # Table statistics
  nodetool tablehistograms myapp.users  # Read/write latency
  nodetool compactionstats     # Running compactions
  nodetool tpstats             # Thread pool stats
  nodetool repair              # Anti-entropy repair
  nodetool cleanup             # Remove data not belonging to node
  nodetool decommission        # Remove node from cluster
  nodetool drain               # Flush and stop accepting writes
  nodetool snapshot            # Create snapshot backup

CONSISTENCY LEVELS:
  ONE           Fastest, lowest consistency
  QUORUM        Majority of replicas (recommended)
  LOCAL_QUORUM  Majority in local DC
  ALL           All replicas must respond
  LOCAL_ONE     One replica in local DC

  Reads:  SELECT * FROM users WHERE id = ? USING CONSISTENCY QUORUM;
  Writes: consistency = QUORUM in driver config

  Rule of thumb:
    Write QUORUM + Read QUORUM = Strong consistency
    (given replication_factor ≥ 3)

COMPACTION STRATEGIES:
  SizeTiered (STCS):   Default, good for write-heavy
  Leveled (LCS):       Better for read-heavy, more I/O
  TimeWindow (TWCS):   Best for time-series data with TTL

  ALTER TABLE sensor_data
    WITH compaction = {'class': 'TimeWindowCompactionStrategy',
                       'compaction_window_size': '1',
                       'compaction_window_unit': 'DAYS'};

BACKUP & RESTORE:
  # Snapshot (hard links, instant)
  nodetool snapshot -t backup_20260324 myapp

  # Snapshots stored in:
  # /var/lib/cassandra/data/myapp/users-<id>/snapshots/backup_20260324/

  # Restore: copy snapshot SSTables back to data directory

SCALING:
  # Add node
  1. Install Cassandra on new server
  2. Set seeds and cluster_name in cassandra.yaml
  3. Start Cassandra — auto-joins and streams data
  4. Run nodetool cleanup on existing nodes

  # Remove node
  nodetool decommission  # On the node being removed

MONITORING:
  Key metrics:
  - Read/write latency (p99)
  - Compaction pending
  - Dropped mutations
  - Heap usage
  - SSTable count per table

  Tools: Prometheus + cassandra_exporter, DataStax OpsCenter

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Apache Cassandra - Distributed NoSQL Reference

Commands:
  intro       Architecture, features, comparison
  cql         CQL queries, data types, batch
  modeling    Query-driven design, partition keys, indexes
  operations  nodetool, consistency, compaction, scaling

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  cql)        cmd_cql ;;
  modeling)   cmd_modeling ;;
  operations) cmd_operations ;;
  help|*)     show_help ;;
esac
