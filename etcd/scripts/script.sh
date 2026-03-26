#!/bin/bash
# etcd - Distributed Key-Value Store Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ETCD REFERENCE                                 ║
║          Distributed Key-Value Store for Config             ║
╚══════════════════════════════════════════════════════════════╝

etcd is a strongly consistent, distributed key-value store used
for shared configuration, service discovery, and coordination.
It's the backbone of Kubernetes (stores all cluster state).

KEY FEATURES:
  Strong consistency  Raft consensus (linearizable reads/writes)
  Watch               Real-time notifications on key changes
  Leases              TTL-based key expiration
  Transactions        Atomic compare-and-swap operations
  MVCC                Multi-version concurrency control
  gRPC API            High-performance binary protocol

USE CASES:
  Kubernetes     All cluster state (pods, services, configs)
  Service discovery  Register/discover services
  Leader election    Distributed lock + election
  Config mgmt    Shared configuration across services
  Feature flags  Dynamic feature toggles
EOF
}

cmd_operations() {
cat << 'EOF'
KEY-VALUE OPERATIONS
======================

ETCDCTL:
  export ETCDCTL_API=3    # Always use v3 API

PUT:
  etcdctl put mykey "myvalue"
  etcdctl put /config/database/host "db.example.com"
  etcdctl put /config/database/port "5432"
  etcdctl put /services/web/instance1 '{"host":"10.0.0.1","port":8080}'

GET:
  etcdctl get mykey                          # Single key
  etcdctl get mykey --print-value-only       # Value only
  etcdctl get /config/database/ --prefix     # All under prefix
  etcdctl get /config/ --prefix --keys-only  # Keys only
  etcdctl get "" --prefix --limit=10         # First 10 keys
  etcdctl get /config/ --prefix --sort-by=KEY --order=ASCEND

DELETE:
  etcdctl del mykey                          # Single key
  etcdctl del /config/ --prefix              # All under prefix
  etcdctl del "" --prefix                    # Delete everything!

WATCH (real-time):
  # Watch single key
  etcdctl watch mykey

  # Watch prefix
  etcdctl watch /services/ --prefix

  # Watch with previous value
  etcdctl watch /config/ --prefix --prev-kv

LEASE (TTL):
  # Create lease (60 second TTL)
  etcdctl lease grant 60
  # Returns: lease 694d7c3f3f1d5c1f granted with TTL(60s)

  # Put with lease (auto-deletes when lease expires)
  etcdctl put /services/web/instance1 '{"host":"10.0.0.1"}' --lease=694d7c3f3f1d5c1f

  # Keep alive (heartbeat)
  etcdctl lease keep-alive 694d7c3f3f1d5c1f

  # Revoke (immediately expire)
  etcdctl lease revoke 694d7c3f3f1d5c1f

  # List leases
  etcdctl lease list

TRANSACTIONS (atomic):
  # Compare-and-swap
  etcdctl txn <<EOF
  compares:
  value("counter") = "5"

  success requests:
  put counter 6

  failure requests:
  get counter
  EOF

  # One-liner
  etcdctl txn --interactive
  # compares: value("lock") = ""
  # success: put lock "holder1"
  # failure: get lock
EOF
}

cmd_cluster() {
cat << 'EOF'
CLUSTER & ADMINISTRATION
===========================

INSTALL:
  # Binary
  ETCD_VER=v3.5.12
  curl -L https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz | tar xz

  # Docker
  docker run -d -p 2379:2379 -p 2380:2380 quay.io/coreos/etcd:v3.5.12 \
    /usr/local/bin/etcd --advertise-client-urls http://0.0.0.0:2379 \
    --listen-client-urls http://0.0.0.0:2379

3-NODE CLUSTER:
  # Node 1
  etcd --name node1 \
    --initial-advertise-peer-urls http://10.0.0.1:2380 \
    --listen-peer-urls http://10.0.0.1:2380 \
    --listen-client-urls http://10.0.0.1:2379,http://127.0.0.1:2379 \
    --advertise-client-urls http://10.0.0.1:2379 \
    --initial-cluster node1=http://10.0.0.1:2380,node2=http://10.0.0.2:2380,node3=http://10.0.0.3:2380 \
    --initial-cluster-state new

HEALTH:
  etcdctl endpoint health
  etcdctl endpoint status --write-out=table
  etcdctl member list --write-out=table

BACKUP:
  # Snapshot save
  etcdctl snapshot save backup.db

  # Snapshot status
  etcdctl snapshot status backup.db --write-out=table

  # Restore
  etcdctl snapshot restore backup.db \
    --name node1 \
    --data-dir /var/lib/etcd-restored

AUTHENTICATION:
  etcdctl user add root --new-user-password="rootpass"
  etcdctl role add readwrite
  etcdctl role grant-permission readwrite readwrite /config/ --prefix
  etcdctl user grant-role root root
  etcdctl auth enable

  # With auth
  etcdctl --user=root:rootpass put /config/key value

TLS:
  etcd \
    --cert-file=/etc/etcd/server.crt \
    --key-file=/etc/etcd/server.key \
    --trusted-ca-file=/etc/etcd/ca.crt \
    --client-cert-auth \
    --peer-cert-file=/etc/etcd/peer.crt \
    --peer-key-file=/etc/etcd/peer.key \
    --peer-trusted-ca-file=/etc/etcd/ca.crt

MONITORING:
  # Prometheus metrics
  curl http://localhost:2379/metrics

  Key metrics:
  - etcd_server_has_leader (1 = healthy)
  - etcd_disk_wal_fsync_duration_seconds
  - etcd_network_peer_round_trip_time_seconds
  - etcd_server_proposals_committed_total
  - etcd_debugging_mvcc_db_total_size_in_bytes

PERFORMANCE TUNING:
  --snapshot-count=10000        # Compact after N transactions
  --heartbeat-interval=100     # Leader heartbeat (ms)
  --election-timeout=1000      # Election timeout (ms)
  --max-request-bytes=1572864  # Max request size (1.5MB)
  --quota-backend-bytes=8589934592  # DB size limit (8GB)

  # Compaction (reclaim space)
  etcdctl compact $(etcdctl endpoint status --write-out="json" | jq '.[0].Status.header.revision')
  etcdctl defrag

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
etcd - Distributed Key-Value Store Reference

Commands:
  intro      Overview, features, use cases
  operations Put/get/watch, leases, transactions
  cluster    Setup, backup, auth, TLS, monitoring

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  operations) cmd_operations ;;
  cluster)    cmd_cluster ;;
  help|*)     show_help ;;
esac
