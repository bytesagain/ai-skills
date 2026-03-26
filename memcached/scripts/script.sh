#!/bin/bash
# Memcached - Distributed Memory Cache Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              MEMCACHED REFERENCE                            ║
║          High-Performance Distributed Memory Cache          ║
╚══════════════════════════════════════════════════════════════╝

Memcached is a simple, high-performance distributed memory
caching system. It caches database queries, API responses,
and session data to reduce backend load.

MEMCACHED vs REDIS:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ Memcached    │ Redis        │
  ├──────────────┼──────────────┼──────────────┤
  │ Data types   │ Strings only │ Rich types   │
  │ Persistence  │ No           │ Yes          │
  │ Threading    │ Multi-thread │ Single-thread│
  │ Memory       │ Slab allocator│ jemalloc    │
  │ Clustering   │ Client-side  │ Server-side  │
  │ Pub/Sub      │ No           │ Yes          │
  │ Lua scripts  │ No           │ Yes          │
  │ Best for     │ Simple cache │ Multi-purpose│
  │ Complexity   │ Very simple  │ Feature-rich │
  └──────────────┴──────────────┴──────────────┘

WHEN TO CHOOSE MEMCACHED:
  - Simple key-value caching only
  - Multi-threaded performance matters
  - Don't need persistence
  - Don't need complex data structures
  - Facebook, Wikipedia, Twitter use it

INSTALL:
  sudo apt install memcached libmemcached-tools
  brew install memcached
  docker run -d -p 11211:11211 memcached
EOF
}

cmd_usage() {
cat << 'EOF'
COMMANDS & CLIENT USAGE
=========================

TELNET PROTOCOL:
  telnet localhost 11211

  set mykey 0 300 5          # set key flags expiry bytes
  hello                       # value
  STORED

  get mykey                   # retrieve
  VALUE mykey 0 5
  hello
  END

  add mykey 0 300 5          # add (only if not exists)
  replace mykey 0 300 5      # replace (only if exists)
  append mykey 0 0 6         # append to value
  prepend mykey 0 0 6        # prepend to value
  delete mykey               # delete
  incr counter 1             # increment numeric value
  decr counter 1             # decrement
  flush_all                  # clear everything
  stats                      # server statistics
  stats items                # item statistics
  stats slabs                # slab statistics

PYTHON:
  pip install pymemcache

  from pymemcache.client.base import Client
  client = Client('localhost:11211')

  # Basic operations
  client.set('user:123', '{"name":"Alice"}', expire=300)
  result = client.get('user:123')    # bytes or None

  # Multi-get
  results = client.get_many(['key1', 'key2', 'key3'])

  # Cache-aside pattern
  def get_user(user_id):
      key = f'user:{user_id}'
      data = client.get(key)
      if data:
          return json.loads(data)
      user = db.query(f'SELECT * FROM users WHERE id={user_id}')
      client.set(key, json.dumps(user), expire=600)
      return user

  # Consistent hashing (distributed)
  from pymemcache.client.hash import HashClient
  client = HashClient([
      'cache1:11211',
      'cache2:11211',
      'cache3:11211',
  ])

NODE.JS:
  npm install memjs

  const memjs = require('memjs');
  const client = memjs.Client.create('localhost:11211');

  await client.set('key', 'value', { expires: 300 });
  const { value } = await client.get('key');
EOF
}

cmd_operations() {
cat << 'EOF'
PRODUCTION & MONITORING
=========================

CONFIG (/etc/memcached.conf):
  -m 2048              # Max memory (MB)
  -c 1024              # Max connections
  -p 11211             # Port
  -l 0.0.0.0           # Listen address
  -t 4                 # Threads
  -I 2m                # Max item size (default 1MB)
  -f 1.25              # Slab growth factor
  -v                   # Verbose logging

KUBERNETES:
  apiVersion: apps/v1
  kind: Deployment
  spec:
    replicas: 3
    template:
      spec:
        containers:
          - name: memcached
            image: memcached:1.6
            args: ["-m", "256", "-c", "1024", "-t", "4"]
            ports:
              - containerPort: 11211
            resources:
              requests:
                memory: 256Mi
                cpu: 250m
              limits:
                memory: 512Mi

MONITORING:
  # memcached-exporter for Prometheus
  docker run -d -p 9150:9150 \
    prom/memcached-exporter \
    --memcached.address=localhost:11211

  # Key metrics to watch:
  stats                      # Total stats
  - curr_items               # Current items stored
  - get_hits / get_misses    # Hit ratio (aim >90%)
  - evictions                # Items evicted (memory full)
  - bytes                    # Current bytes used
  - limit_maxbytes           # Max bytes configured
  - curr_connections         # Active connections
  - cmd_get / cmd_set        # Get/set rate

  # Hit ratio calculation:
  hit_ratio = get_hits / (get_hits + get_misses) * 100

EVICTION POLICY:
  - LRU (Least Recently Used) — default
  - Items evicted when memory full
  - No TTL sweep — expired items evicted lazily
  - Set appropriate TTL to prevent stale data

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Memcached - Distributed Memory Cache Reference

Commands:
  intro       Overview, vs Redis
  usage       Protocol, Python, Node.js clients
  operations  Config, K8s, monitoring, eviction

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  usage)      cmd_usage ;;
  operations) cmd_operations ;;
  help|*)     show_help ;;
esac
