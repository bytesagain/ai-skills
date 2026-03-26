#!/bin/bash
# ScyllaDB - High-Performance Cassandra Alternative Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              SCYLLADB REFERENCE                             ║
║          Cassandra at 10x the Speed                         ║
╚══════════════════════════════════════════════════════════════╝

ScyllaDB is a drop-in Apache Cassandra replacement written in
C++ instead of Java. Same CQL protocol, 10x lower latency,
predictable performance with shard-per-core architecture.

KEY FEATURES:
  10x faster       C++ vs Java, shard-per-core design
  CQL compatible   Drop-in Cassandra replacement
  Auto-tuning      Self-optimizing (no JVM tuning needed)
  Shard-per-core   Each CPU core owns its data shard
  Low latency      P99 latencies 10-100x lower than Cassandra
  Seastar          Async framework, zero-copy, zero-lock

SCYLLADB vs CASSANDRA vs DYNAMODB:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ ScyllaDB │Cassandra │ DynamoDB │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Language     │ C++      │ Java     │ Managed  │
  │ Query        │ CQL      │ CQL     │ PartiQL  │
  │ Latency P99  │ <1ms     │ 5-50ms  │ <10ms    │
  │ Tuning       │ Auto     │ Manual  │ Auto     │
  │ Throughput   │ 1M ops/s │ 100K/s  │ On-demand│
  │ License      │ AGPL/Ent │ Apache2 │ Managed  │
  │ Hosting      │ Self/Cloud│ Self/Cloud│ AWS    │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Docker
  docker run --name scylla -p 9042:9042 scylladb/scylla

  # Connect with cqlsh
  docker exec -it scylla cqlsh
EOF
}

cmd_cql() {
cat << 'EOF'
CQL (Cassandra Query Language)
=================================

KEYSPACE (like database):
  CREATE KEYSPACE myapp WITH replication = {
      'class': 'NetworkTopologyStrategy',
      'dc1': 3
  };
  USE myapp;

TABLE DESIGN (denormalize for queries):
  -- Rule: Design tables around your queries, not your entities
  -- Each query pattern = one table

  -- Users by ID
  CREATE TABLE users (
      user_id UUID PRIMARY KEY,
      name TEXT,
      email TEXT,
      created_at TIMESTAMP
  );

  -- Posts by user (ordered by time)
  CREATE TABLE posts_by_user (
      user_id UUID,
      post_id TIMEUUID,
      title TEXT,
      body TEXT,
      PRIMARY KEY (user_id, post_id)
  ) WITH CLUSTERING ORDER BY (post_id DESC);

  -- Posts by tag (partition per tag)
  CREATE TABLE posts_by_tag (
      tag TEXT,
      post_id TIMEUUID,
      title TEXT,
      user_id UUID,
      PRIMARY KEY (tag, post_id)
  ) WITH CLUSTERING ORDER BY (post_id DESC);

PRIMARY KEY ANATOMY:
  PRIMARY KEY (partition_key)
  PRIMARY KEY (partition_key, clustering_key)
  PRIMARY KEY ((part1, part2), clust1, clust2)

  Partition key   → which node stores the data
  Clustering key  → sort order within the partition

QUERIES:
  -- Always include partition key!
  SELECT * FROM posts_by_user WHERE user_id = ?;
  SELECT * FROM posts_by_user WHERE user_id = ? AND post_id > ?;
  SELECT * FROM posts_by_tag WHERE tag = 'python' LIMIT 20;

  -- Token range scan (full table)
  SELECT * FROM users WHERE token(user_id) > ? LIMIT 100;

  -- ALLOW FILTERING (use sparingly, scans all partitions)
  SELECT * FROM users WHERE name = 'Alice' ALLOW FILTERING;

BATCH (atomic within partition):
  BEGIN BATCH
      INSERT INTO posts_by_user (...) VALUES (...);
      INSERT INTO posts_by_tag (...) VALUES (...);
  APPLY BATCH;

TTL (auto-expire):
  INSERT INTO sessions (id, data) VALUES (?, ?) USING TTL 3600;
  SELECT TTL(data) FROM sessions WHERE id = ?;

MATERIALIZED VIEWS:
  CREATE MATERIALIZED VIEW users_by_email AS
      SELECT * FROM users
      WHERE email IS NOT NULL AND user_id IS NOT NULL
      PRIMARY KEY (email, user_id);

SECONDARY INDEX (use carefully):
  CREATE INDEX ON users (email);
  -- Local index: queries still need partition key
  -- Global index (ScyllaDB): can query without partition key
EOF
}

cmd_ops() {
cat << 'EOF'
OPERATIONS & DRIVERS
======================

NODETOOL:
  nodetool status            # Cluster status
  nodetool info              # Node info
  nodetool ring              # Token ring
  nodetool tablestats myapp  # Table statistics
  nodetool compactionstats   # Compaction status
  nodetool repair            # Run repair
  nodetool cleanup           # Remove data that no longer belongs
  nodetool flush             # Flush memtables to SSTables
  nodetool drain             # Flush + stop accepting writes

  # ScyllaDB specific
  nodetool toppartitions     # Hot partition detection
  nodetool workload_priorities  # Workload manager

SCYLLA-SPECIFIC FEATURES:
  -- Lightweight transactions (IF NOT EXISTS)
  INSERT INTO users (user_id, name)
  VALUES (uuid(), 'Alice')
  IF NOT EXISTS;

  -- Counter tables
  CREATE TABLE page_views (
      page TEXT PRIMARY KEY,
      views COUNTER
  );
  UPDATE page_views SET views = views + 1 WHERE page = '/home';

  -- Change Data Capture (CDC)
  ALTER TABLE users WITH cdc = {'enabled': true};

PYTHON DRIVER:
  from cassandra.cluster import Cluster
  cluster = Cluster(['scylla-node1', 'scylla-node2'])
  session = cluster.connect('myapp')

  # Prepared statements (must use for production)
  stmt = session.prepare("SELECT * FROM users WHERE user_id = ?")
  result = session.execute(stmt, [user_id])
  for row in result:
      print(row.name, row.email)

  # Async
  future = session.execute_async(stmt, [user_id])
  result = future.result()

  # Batch
  from cassandra.query import BatchStatement
  batch = BatchStatement()
  batch.add(stmt1, params1)
  batch.add(stmt2, params2)
  session.execute(batch)

MIGRATION FROM CASSANDRA:
  1. Same CQL, same drivers, same tools
  2. Export schema: cqlsh -e "DESC KEYSPACE myapp" > schema.cql
  3. sstableloader or spark for data migration
  4. Point drivers to ScyllaDB nodes (same port 9042)
  5. No code changes needed

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
ScyllaDB - High-Performance Cassandra Alternative Reference

Commands:
  intro    Overview, comparison with Cassandra
  cql      CQL, table design, primary keys, TTL
  ops      Nodetool, drivers, migration

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  cql)   cmd_cql ;;
  ops)   cmd_ops ;;
  help|*) show_help ;;
esac
