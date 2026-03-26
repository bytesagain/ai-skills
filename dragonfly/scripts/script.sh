#!/bin/bash
# Dragonfly - Modern Redis Alternative Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              DRAGONFLY REFERENCE                            ║
║          Modern In-Memory Data Store                        ║
╚══════════════════════════════════════════════════════════════╝

Dragonfly is a modern, multi-threaded in-memory data store that
is fully compatible with Redis and Memcached APIs. It achieves
25x throughput vs Redis on a single instance.

KEY FEATURES:
  Multi-threaded   Uses all CPU cores (Redis is single-threaded)
  25x throughput   4M ops/sec vs Redis 160K ops/sec
  Redis compatible Drop-in replacement (RESP protocol)
  Memcached compat Also supports Memcached protocol
  Memory efficient Uses dashtable (less memory than Redis)
  Snapshotting     Non-blocking point-in-time snapshots
  No cluster       Single instance handles what Redis cluster does

DRAGONFLY vs REDIS vs KEYDB vs VALKEY:
  ┌──────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature      │Dragonfly │ Redis    │ KeyDB    │ Valkey   │
  ├──────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Threading    │ Multi    │ Single   │ Multi    │ Single   │
  │ Throughput   │ 4M ops/s │ 160K/s   │ 500K/s   │ 170K/s   │
  │ Memory       │ Lower    │ Baseline │ Similar  │ Baseline │
  │ Cluster      │ Emulated │ Native   │ Multi-master│ Native │
  │ License      │ BSL      │ SSPL*    │ BSD      │ BSD      │
  │ API compat   │ Redis    │ Redis    │ Redis    │ Redis    │
  │ Snapshots    │ No-fork  │ Fork     │ Fork     │ Fork     │
  └──────────────┴──────────┴──────────┴──────────┴──────────┘
  * Redis 7.4+ changed to SSPL; Valkey is the BSD fork

INSTALL:
  # Docker
  docker run --name dragonfly -p 6379:6379 docker.dragonflydb.io/dragonflydb/dragonfly

  # Binary
  curl -fsSL https://get.dragonflydb.io | sh

  # Connect with any Redis client
  redis-cli -p 6379
EOF
}

cmd_usage() {
cat << 'EOF'
USAGE & REDIS COMPATIBILITY
==============================

COMPATIBLE COMMANDS:
  All standard Redis commands work:
  SET key value EX 3600
  GET key
  DEL key
  MSET k1 v1 k2 v2
  MGET k1 k2
  INCR counter
  EXPIRE key 300
  TTL key
  KEYS pattern
  SCAN 0 MATCH user:* COUNT 100

DATA STRUCTURES:
  # Strings
  SET session:abc '{"user":"alice"}'
  GET session:abc

  # Hashes
  HSET user:1 name "Alice" age 30 email "a@b.com"
  HGET user:1 name
  HGETALL user:1
  HINCRBY user:1 age 1

  # Lists
  LPUSH queue:jobs '{"type":"email"}'
  RPOP queue:jobs
  LRANGE queue:jobs 0 -1

  # Sets
  SADD online:users "alice" "bob" "charlie"
  SISMEMBER online:users "alice"
  SCARD online:users
  SINTER online:users premium:users

  # Sorted Sets
  ZADD leaderboard 1000 "alice" 900 "bob" 850 "charlie"
  ZRANGE leaderboard 0 -1 WITHSCORES
  ZREVRANK leaderboard "alice"
  ZRANGEBYSCORE leaderboard 900 +inf

  # Streams
  XADD events * type click page /home user alice
  XREAD COUNT 10 STREAMS events 0
  XRANGE events - + COUNT 10

  # JSON (RedisJSON compatible)
  JSON.SET user:1 $ '{"name":"Alice","scores":[90,85,95]}'
  JSON.GET user:1 $.name
  JSON.NUMINCRBY user:1 $.scores[0] 5

  # Pub/Sub
  SUBSCRIBE channel
  PUBLISH channel "message"

  # Lua scripting
  EVAL "return redis.call('GET', KEYS[1])" 1 mykey

DRAGONFLY-SPECIFIC:
  # Memory usage
  INFO memory
  MEMORY USAGE key

  # Server info
  INFO server
  INFO clients
  INFO stats

  # Debug
  DEBUG OBJECT key
  SLOWLOG GET 10
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION & OPERATIONS
=============================

FLAGS (command line):
  dragonfly --port 6379
  dragonfly --maxmemory 8gb
  dragonfly --dbnum 16
  dragonfly --requirepass mysecret
  dragonfly --dir /data/dragonfly          # Snapshot dir
  dragonfly --snapshot_cron "*/30 * * * *"  # Snapshot every 30min
  dragonfly --keys_output_limit 8192       # KEYS result limit
  dragonfly --hz 100                       # Internal timer freq
  dragonfly --proactor_threads 8           # Worker threads
  dragonfly --cache_mode                   # LRU eviction mode

SNAPSHOT (non-blocking):
  SAVE                    # Trigger snapshot
  BGSAVE                  # Same as SAVE (no fork needed!)
  DBSIZE                  # Key count
  FLUSHDB                 # Clear current DB
  FLUSHALL                # Clear all DBs

  # Dragonfly snapshots are non-blocking:
  # No fork(), no memory spike, no latency spike
  # This is a major advantage over Redis

MIGRATION FROM REDIS:
  1. Start Dragonfly on a different port
  2. Use SLAVEOF/REPLICAOF to sync from Redis
     REPLICAOF redis-host 6379
  3. Wait for sync to complete
  4. REPLICAOF NO ONE
  5. Point clients to Dragonfly

  # Or use redis-cli --pipe
  redis-cli -h redis-host --rdb /tmp/dump.rdb
  redis-cli -h dragonfly-host --pipe < /tmp/dump.rdb

CLIENT LIBRARIES:
  # Python (redis-py works unchanged)
  import redis
  r = redis.Redis(host='localhost', port=6379)
  r.set('key', 'value')
  r.get('key')

  # Node.js (ioredis works unchanged)
  const Redis = require('ioredis')
  const r = new Redis(6379, 'localhost')

  # Go (go-redis works unchanged)
  rdb := redis.NewClient(&redis.Options{Addr: "localhost:6379"})

  # Any Redis client works — no code changes needed

DOCKER COMPOSE:
  services:
    dragonfly:
      image: docker.dragonflydb.io/dragonflydb/dragonfly
      ports:
        - "6379:6379"
      volumes:
        - dragonfly-data:/data
      command: >
        --maxmemory 4gb
        --snapshot_cron "0 */6 * * *"
        --requirepass ${REDIS_PASSWORD}

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Dragonfly - Modern In-Memory Data Store Reference

Commands:
  intro    Overview, comparison with Redis/KeyDB/Valkey
  usage    Redis-compatible commands, data structures
  config   Flags, snapshots, migration, Docker

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  usage)  cmd_usage ;;
  config) cmd_config ;;
  help|*) show_help ;;
esac
