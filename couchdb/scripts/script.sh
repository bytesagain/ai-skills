#!/bin/bash
# CouchDB - Document Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              COUCHDB REFERENCE                              ║
║          Reliable Document Database with Sync               ║
╚══════════════════════════════════════════════════════════════╝

Apache CouchDB is a document database with multi-master
replication and conflict resolution. It uses HTTP/REST API
natively — no special driver needed.

KEY FEATURES:
  Document store     JSON documents
  REST API           Pure HTTP (curl-friendly)
  Replication        Multi-master, offline-first
  MVCC               Multi-version concurrency
  MapReduce          JavaScript views
  Mango              MongoDB-like query language
  Fauxton            Built-in web admin UI

COUCHDB vs MONGODB:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ CouchDB      │ MongoDB      │
  ├──────────────┼──────────────┼──────────────┤
  │ API          │ HTTP/REST    │ Binary (BSON)│
  │ Replication  │ Multi-master │ Replica set  │
  │ Conflict     │ Built-in     │ Last-write   │
  │ Offline      │ PouchDB sync │ Realm sync   │
  │ Query        │ Mango/Views  │ MQL          │
  │ Scale        │ Cluster      │ Sharded      │
  │ Best for     │ Sync/offline │ General      │
  └──────────────┴──────────────┴──────────────┘

INSTALL:
  docker run -d -p 5984:5984 \
    -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=secret \
    couchdb:3
  # Fauxton UI: http://localhost:5984/_utils
EOF
}

cmd_api() {
cat << 'EOF'
HTTP API
==========

DATABASE:
  curl -X PUT http://admin:secret@localhost:5984/mydb
  curl http://admin:secret@localhost:5984/_all_dbs
  curl -X DELETE http://admin:secret@localhost:5984/mydb

DOCUMENTS:
  # Create (auto-generate ID)
  curl -X POST http://localhost:5984/mydb \
    -H "Content-Type: application/json" \
    -d '{"name":"Alice","age":30}'

  # Create with ID
  curl -X PUT http://localhost:5984/mydb/user001 \
    -H "Content-Type: application/json" \
    -d '{"name":"Alice","age":30}'

  # Read
  curl http://localhost:5984/mydb/user001

  # Update (must include _rev)
  curl -X PUT http://localhost:5984/mydb/user001 \
    -d '{"_rev":"1-abc123","name":"Alice","age":31}'

  # Delete
  curl -X DELETE http://localhost:5984/mydb/user001?rev=2-def456

  # Bulk insert
  curl -X POST http://localhost:5984/mydb/_bulk_docs \
    -H "Content-Type: application/json" \
    -d '{"docs":[{"name":"Bob"},{"name":"Carol"}]}'

  # All docs
  curl http://localhost:5984/mydb/_all_docs?include_docs=true

MANGO QUERIES:
  # Find by field
  curl -X POST http://localhost:5984/mydb/_find \
    -H "Content-Type: application/json" \
    -d '{"selector":{"age":{"$gt":25}},"limit":10}'

  # Complex query
  curl -X POST http://localhost:5984/mydb/_find \
    -d '{"selector":{"$and":[{"type":"user"},{"status":"active"}]},
         "fields":["name","email"],
         "sort":[{"created":"desc"}],
         "limit":20}'

  # Create index
  curl -X POST http://localhost:5984/mydb/_index \
    -d '{"index":{"fields":["type","created"]},"name":"type-date"}'
EOF
}

cmd_replication() {
cat << 'EOF'
REPLICATION & VIEWS
=====================

REPLICATION:
  # One-time replication
  curl -X POST http://localhost:5984/_replicate \
    -d '{"source":"mydb","target":"http://remote:5984/mydb"}'

  # Continuous replication
  curl -X POST http://localhost:5984/_replicate \
    -d '{"source":"mydb","target":"http://remote:5984/mydb",
         "continuous":true}'

  # Filtered replication
  curl -X POST http://localhost:5984/_replicate \
    -d '{"source":"mydb","target":"backup",
         "filter":"mydesign/by_type",
         "query_params":{"type":"important"}}'

  # PouchDB (browser/offline sync)
  const db = new PouchDB('local');
  db.sync('http://localhost:5984/mydb', { live: true, retry: true });

CONFLICT RESOLUTION:
  # CouchDB keeps ALL conflicting revisions
  # Get conflicts
  curl http://localhost:5984/mydb/doc001?conflicts=true
  # Response: {"_conflicts": ["2-xyz789"]}

  # Get conflicting revision
  curl http://localhost:5984/mydb/doc001?rev=2-xyz789

  # Resolve: keep winner, delete loser
  curl -X DELETE http://localhost:5984/mydb/doc001?rev=2-xyz789

MAPREDUCE VIEWS:
  # Design document with view
  {
    "_id": "_design/stats",
    "views": {
      "by_type": {
        "map": "function(doc) { emit(doc.type, 1); }",
        "reduce": "_count"
      },
      "by_date": {
        "map": "function(doc) { if(doc.created) emit(doc.created, doc); }"
      }
    }
  }

  # Query view
  curl http://localhost:5984/mydb/_design/stats/_view/by_type?group=true
  curl http://localhost:5984/mydb/_design/stats/_view/by_date?startkey="2026-01-01"&limit=10

CLUSTERING:
  # CouchDB 3.x supports clustering natively
  # Each node stores a shard of the data
  # N=3 replicas, Q=8 shards by default
  curl -X PUT http://localhost:5984/mydb?n=3&q=8

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
CouchDB - Document Database Reference

Commands:
  intro         Overview, vs MongoDB
  api           HTTP API, CRUD, Mango queries
  replication   Sync, conflicts, views, clustering

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  api)         cmd_api ;;
  replication) cmd_replication ;;
  help|*)      show_help ;;
esac
