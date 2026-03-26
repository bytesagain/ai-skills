#!/bin/bash
# ZooKeeper - Distributed Coordination Service Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ZOOKEEPER REFERENCE                            ║
║          Distributed Coordination Service                   ║
╚══════════════════════════════════════════════════════════════╝

Apache ZooKeeper provides distributed coordination: config
management, leader election, distributed locks, service
discovery, and cluster membership. Used by Kafka, Hadoop,
HBase, Solr, and many distributed systems.

DATA MODEL:
  ZooKeeper uses a hierarchical namespace (like a filesystem):

  /
  ├── kafka/
  │   ├── brokers/
  │   │   ├── ids/
  │   │   │   ├── 0          # Broker metadata
  │   │   │   └── 1
  │   │   └── topics/
  │   └── controller         # Current controller
  ├── myapp/
  │   ├── config             # App configuration
  │   ├── leader             # Leader election
  │   └── locks/             # Distributed locks
  └── services/
      └── web/
          ├── instance-001   # Service instance
          └── instance-002

NODE TYPES:
  Persistent           Survives client disconnect
  Ephemeral            Deleted when client disconnects
  Persistent Sequential Auto-incrementing suffix
  Ephemeral Sequential  Ephemeral + sequential
  Container            Auto-deleted when empty (3.6+)
  TTL                  Auto-deleted after TTL (3.6+)
EOF
}

cmd_usage() {
cat << 'EOF'
CLI & RECIPES
===============

CLI (zkCli.sh):
  ./bin/zkCli.sh -server localhost:2181

  # CRUD
  create /myapp/config '{"db":"localhost:5432"}'
  get /myapp/config
  set /myapp/config '{"db":"newhost:5432"}'
  delete /myapp/config
  ls /myapp

  # Ephemeral node (deleted when client disconnects)
  create -e /services/web/instance-001 '{"host":"10.0.0.1","port":8080}'

  # Sequential node
  create -s /locks/lock- ""
  # Creates /locks/lock-0000000001

  # Watch (one-time notification)
  get -w /myapp/config
  ls -w /myapp

  # ACLs
  getAcl /myapp
  setAcl /myapp world:anyone:r    # Read-only for everyone
  setAcl /myapp digest:user:password:cdrwa

LEADER ELECTION:
  1. Each candidate creates ephemeral sequential node
     /election/candidate-0000000001
     /election/candidate-0000000002

  2. Get all children, sort by sequence number

  3. Lowest sequence number = leader

  4. Others watch the node just before them

  5. If watched node deleted → check if now leader

DISTRIBUTED LOCK:
  1. Create ephemeral sequential: /locks/lock-
     → /locks/lock-0000000005

  2. Get all children of /locks

  3. If my node is lowest → lock acquired

  4. Otherwise, watch the next lowest node

  5. On notification → re-check if lowest

  6. Delete node to release lock

SERVICE DISCOVERY:
  # Register service
  create -e /services/api/instance-001 \
    '{"host":"10.0.0.1","port":8080","version":"2.1"}'

  # Discover services
  ls /services/api
  # → [instance-001, instance-002, instance-003]

  # Watch for changes
  ls -w /services/api
  # Notified when instances join/leave
EOF
}

cmd_operations() {
cat << 'EOF'
CLUSTER & OPERATIONS
======================

ENSEMBLE CONFIG (zoo.cfg):
  tickTime=2000
  dataDir=/var/zookeeper
  clientPort=2181
  initLimit=5
  syncLimit=2

  # Cluster members (minimum 3 for quorum)
  server.1=zoo1:2888:3888
  server.2=zoo2:2888:3888
  server.3=zoo3:2888:3888
  # Port 2888: follower-to-leader
  # Port 3888: leader election

  # Each node needs myid file
  echo "1" > /var/zookeeper/myid    # On zoo1
  echo "2" > /var/zookeeper/myid    # On zoo2

QUORUM:
  3 nodes → tolerates 1 failure
  5 nodes → tolerates 2 failures
  7 nodes → tolerates 3 failures
  Formula: can lose (N-1)/2 nodes

KUBERNETES:
  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: zookeeper
  spec:
    replicas: 3
    serviceName: zookeeper-headless
    template:
      spec:
        containers:
          - name: zookeeper
            image: bitnami/zookeeper:3.9
            ports:
              - containerPort: 2181
              - containerPort: 2888
              - containerPort: 3888
            env:
              - name: ZOO_SERVER_ID
                valueFrom:
                  fieldRef:
                    fieldPath: metadata.name
              - name: ZOO_SERVERS
                value: "zookeeper-0:2888:3888,zookeeper-1:2888:3888,zookeeper-2:2888:3888"

FOUR LETTER COMMANDS:
  echo ruok | nc localhost 2181     # Health check → "imok"
  echo stat | nc localhost 2181     # Server statistics
  echo mntr | nc localhost 2181     # Monitoring metrics
  echo conf | nc localhost 2181     # Configuration
  echo cons | nc localhost 2181     # Client connections
  echo envi | nc localhost 2181     # Environment
  echo dump | nc localhost 2181     # Sessions + ephemeral nodes
  echo srvr | nc localhost 2181     # Server details

KAFKA + ZOOKEEPER (legacy):
  # Kafka 3.3+ uses KRaft mode (no ZK needed)
  # Legacy Kafka requires ZooKeeper for:
  #   - Broker registration
  #   - Topic metadata
  #   - Controller election
  #   - Consumer group coordination

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
ZooKeeper - Distributed Coordination Reference

Commands:
  intro       Data model, node types
  usage       CLI, leader election, locks, discovery
  operations  Cluster config, K8s, monitoring

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  usage)      cmd_usage ;;
  operations) cmd_operations ;;
  help|*)     show_help ;;
esac
