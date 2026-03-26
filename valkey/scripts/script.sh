#!/bin/bash
# Valkey - The Open-Source Redis Fork Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              VALKEY REFERENCE                               ║
║          The Community Redis Fork                           ║
╚══════════════════════════════════════════════════════════════╝

Valkey is a Linux Foundation project — the community fork of
Redis after Redis Ltd changed to the SSPL license. Backed by
AWS, Google, Oracle, Alibaba, Ericsson, and dozens of Redis
core contributors.

WHY VALKEY EXISTS:
  Redis 7.4 → SSPL license (not truly open-source)
  Community forked → Valkey under BSD-3-Clause
  Linux Foundation governance (neutral, vendor-independent)
  All major cloud providers backing Valkey

VALKEY vs REDIS:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Valkey   │ Redis    │
  ├──────────────┼──────────┼──────────┤
  │ License      │ BSD-3    │ SSPL     │
  │ Governance   │ LF       │ Redis Ltd│
  │ API          │ Same     │ Original │
  │ Cloud hosted │ AWS/GCP  │ Redis Inc│
  │ Community    │ Open     │ Limited  │
  │ Future       │ Community│ Corporate│
  └──────────────┴──────────┴──────────┘

  Commands, protocol, config — all identical to Redis 7.2.x.
  Existing Redis clients work without any code changes.

INSTALL:
  # Docker
  docker run -p 6379:6379 valkey/valkey

  # From source
  git clone https://github.com/valkey-io/valkey.git
  cd valkey && make && make install

  # AWS ElastiCache → now defaults to Valkey
EOF
}

cmd_features() {
cat << 'EOF'
FEATURES & IMPROVEMENTS
==========================

WHAT VALKEY ADDS (beyond Redis 7.2):
  I/O threading    Improved multi-threaded I/O (8.x)
  RDMA support     Remote Direct Memory Access
  Dual channel     Separate channels for primary/replica sync
  Async I/O        Non-blocking disk operations
  Slot migration   Live slot migration for cluster resharding
  Performance      ~15-25% improvement in some benchmarks

ALL REDIS FEATURES WORK:
  # Data structures
  STRING, HASH, LIST, SET, SORTED SET, STREAM, 
  HYPERLOGLOG, BITMAP, GEOSPATIAL

  # Persistence
  RDB snapshots + AOF append-only file

  # Replication
  Primary-replica async replication
  
  # Cluster
  valkey-cli --cluster create host1:6379 host2:6379 host3:6379 \
    --cluster-replicas 1

  # Modules
  valkey-server --loadmodule /path/to/module.so

  # Pub/Sub
  SUBSCRIBE channel
  PUBLISH channel "message"

  # Streams (event log)
  XADD stream * key value
  XREAD BLOCK 5000 STREAMS stream $

  # Lua scripting
  EVAL "return redis.call('GET', KEYS[1])" 1 mykey

  # Functions (Valkey 8.x)
  FUNCTION LOAD "..."
  FCALL myfunction 1 key

CLI DIFFERENCES:
  valkey-cli          # Instead of redis-cli
  valkey-server       # Instead of redis-server
  valkey-benchmark    # Instead of redis-benchmark
  valkey-check-aof    # Instead of redis-check-aof
  valkey-sentinel     # Instead of redis-sentinel

  # But redis-cli still works (protocol is identical)
EOF
}

cmd_ops() {
cat << 'EOF'
OPERATIONS & MIGRATION
=========================

MIGRATE FROM REDIS:
  # Option 1: Direct replacement
  1. Stop Redis
  2. Install Valkey
  3. Copy redis.conf → valkey.conf (or keep redis.conf, both work)
  4. Start Valkey with same data directory
  5. Done — clients connect unchanged

  # Option 2: Live migration via replication
  1. Start Valkey as replica of Redis
     valkey-server --replicaof redis-host 6379
  2. Wait for sync (INFO replication → connected_slaves)
  3. REPLICAOF NO ONE on Valkey
  4. Redirect client connections
  5. Stop Redis

  # Option 3: RDB dump
  redis-cli -h redis-host BGSAVE
  # Copy dump.rdb to Valkey data directory
  valkey-server --dir /path/to/data

CONFIGURATION (valkey.conf):
  bind 0.0.0.0
  port 6379
  requirepass your_password
  maxmemory 8gb
  maxmemory-policy allkeys-lfu

  # Persistence
  save 3600 1 300 100 60 10000
  appendonly yes
  aof-use-rdb-preamble yes

  # Performance
  io-threads 4
  io-threads-do-reads yes

  # TLS
  tls-port 6380
  tls-cert-file /etc/valkey/tls/cert.pem
  tls-key-file /etc/valkey/tls/key.pem

CLUSTER:
  valkey-cli --cluster create \
    node1:6379 node2:6379 node3:6379 \
    node4:6379 node5:6379 node6:6379 \
    --cluster-replicas 1

  valkey-cli --cluster info node1:6379
  valkey-cli --cluster check node1:6379
  valkey-cli --cluster reshard node1:6379

SENTINEL (HA without cluster):
  # sentinel.conf
  sentinel monitor mymaster 192.168.1.1 6379 2
  sentinel down-after-milliseconds mymaster 5000
  sentinel failover-timeout mymaster 10000
  sentinel parallel-syncs mymaster 1

  valkey-sentinel /etc/valkey/sentinel.conf

MONITORING:
  INFO all
  INFO memory
  INFO replication
  INFO stats
  SLOWLOG GET 10
  LATENCY LATEST
  CLIENT LIST

CLOUD SERVICES (using Valkey):
  AWS ElastiCache     Default engine since 2024
  Google MemoryStore  Valkey support
  Alibaba Tair        Valkey-compatible

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Valkey - The Community Redis Fork Reference

Commands:
  intro      Overview, why Valkey exists
  features   Improvements, Redis compatibility
  ops        Migration, config, cluster, sentinel

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  features) cmd_features ;;
  ops)      cmd_ops ;;
  help|*)   show_help ;;
esac
