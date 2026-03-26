#!/bin/bash
# KeyDB - Multi-Threaded Redis Fork Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              KEYDB REFERENCE                                ║
║          Multi-Threaded Redis Fork                          ║
╚══════════════════════════════════════════════════════════════╝

KeyDB is a multi-threaded fork of Redis that maintains full
compatibility while delivering 5x higher throughput. It was
created by Snap Inc. (Snapchat) and is now open-source under BSD.

KEY FEATURES:
  Multi-threaded   Multiple I/O threads (Redis is single-threaded)
  Active-Active    Multi-master replication built-in
  Subkey expires   Expire individual hash fields
  FLASH storage    Tier data to NVMe/SSD automatically
  MVCC             Multi-Version Concurrency Control
  Redis compat     100% API compatible, drop-in replacement

KEYDB vs REDIS vs VALKEY:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ KeyDB    │ Redis    │ Valkey   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Threading    │ Multi    │ Single   │ Single   │
  │ License      │ BSD      │ SSPL     │ BSD      │
  │ Multi-master │ Yes      │ No       │ No       │
  │ Flash tier   │ Yes      │ Enterprise│ No      │
  │ Subkey expiry│ Yes      │ No       │ No       │
  │ Community    │ Snap Inc │ Redis Ltd│ LF       │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Docker
  docker run --name keydb -p 6379:6379 eqalpha/keydb

  # Ubuntu/Debian
  echo "deb https://download.keydb.dev/open-source-dist $(lsb_release -sc) main" | \
    sudo tee /etc/apt/sources.list.d/keydb.list
  sudo apt update && sudo apt install keydb
EOF
}

cmd_features() {
cat << 'EOF'
KEYDB-SPECIFIC FEATURES
==========================

MULTI-THREADING:
  # keydb.conf
  server-threads 4          # I/O threads (default: 2)
  server-thread-affinity true  # Pin threads to CPUs

  # Redis 6+ has io-threads but only for parsing
  # KeyDB threads handle full request lifecycle

ACTIVE-ACTIVE REPLICATION:
  # Multi-master: both nodes accept writes, sync bidirectionally

  # Node A keydb.conf
  active-replica yes
  multi-master yes
  replicaof nodeB 6379

  # Node B keydb.conf
  active-replica yes
  multi-master yes
  replicaof nodeA 6379

  # Both nodes are writable simultaneously
  # Conflict resolution: last-write-wins based on timestamp

  # Three-node setup
  # Node A: replicaof B, replicaof C
  # Node B: replicaof A, replicaof C
  # Node C: replicaof A, replicaof B

SUBKEY EXPIRES:
  # Expire individual hash fields (KeyDB exclusive!)
  HSET user:1 name "Alice" session "abc123"
  EXPIREMEMBER user:1 session 3600
  # After 1 hour, only "session" field is deleted
  # "name" field survives

  PEXPIREMEMBER user:1 session 60000   # Milliseconds
  EXPIREMEMBEROF user:1 session        # Check TTL

  # Use cases:
  # - Rate limiting per action type in a hash
  # - Session fields with different lifetimes
  # - Cache invalidation at field level

FLASH STORAGE (MVCC):
  # Tier cold data to NVMe/SSD automatically
  # keydb.conf
  storage-provider flash /path/to/flash-storage
  maxmemory 4gb              # Hot data in RAM
  # Keys beyond 4GB → NVMe/SSD
  # Reads transparently fetch from flash

  # MVCC enables concurrent reads during flash operations
  # No blocking, no latency spikes

ADDITIONAL:
  # Non-blocking KEYS (safer than Redis)
  KEYS *                     # Won't block other threads

  # Async commands
  # KeyDB processes commands across threads
  # Pipeline performance is dramatically better

  # Scratch variables (server-side temp values)
  SETEX __scratch:temp 10 "processing"
EOF
}

cmd_ops() {
cat << 'EOF'
OPERATIONS & MIGRATION
=========================

CONFIGURATION (keydb.conf):
  bind 0.0.0.0
  port 6379
  requirepass your_password
  server-threads 4
  maxmemory 8gb
  maxmemory-policy allkeys-lfu

  # Persistence
  save 900 1                 # RDB snapshot
  appendonly yes              # AOF
  aof-use-rdb-preamble yes   # Mixed mode (fastest recovery)

  # TLS
  tls-port 6380
  tls-cert-file /path/to/cert.pem
  tls-key-file /path/to/key.pem

MONITORING:
  INFO server
  INFO memory
  INFO stats
  INFO replication

  # KeyDB-specific
  INFO threads              # Thread utilization
  INFO mvcc                 # MVCC stats
  INFO flash                # Flash storage stats

  # Latency
  LATENCY LATEST
  SLOWLOG GET 10
  DEBUG SLEEP 0             # Latency test

BENCHMARKS:
  keydb-benchmark -h localhost -p 6379 -c 50 -n 100000 -t set,get
  redis-benchmark -h localhost -p 6379 -c 50 -n 100000 --threads 4

MIGRATE FROM REDIS:
  1. Install KeyDB
  2. Copy redis.conf → keydb.conf (compatible)
  3. Add: server-threads 4
  4. Stop Redis, start KeyDB
  5. Point clients to KeyDB (same port, same protocol)

  # Or live migration
  keydb-server --replicaof redis-host 6379
  # Wait for sync, then:
  REPLICAOF NO ONE
  # Redirect clients

DOCKER COMPOSE:
  services:
    keydb:
      image: eqalpha/keydb
      ports:
        - "6379:6379"
      volumes:
        - keydb-data:/data
      command: >
        keydb-server
        --server-threads 4
        --requirepass ${REDIS_PASSWORD}
        --appendonly yes
        --maxmemory 4gb
        --maxmemory-policy allkeys-lfu

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
KeyDB - Multi-Threaded Redis Fork Reference

Commands:
  intro      Overview, comparison
  features   Multi-threading, Active-Active, subkey expires, Flash
  ops        Config, monitoring, migration from Redis

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  features) cmd_features ;;
  ops)      cmd_ops ;;
  help|*)   show_help ;;
esac
