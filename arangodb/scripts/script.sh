#!/bin/bash
# ArangoDB - Multi-Model Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ARANGODB REFERENCE                             ║
║          Multi-Model: Document + Graph + Key-Value          ║
╚══════════════════════════════════════════════════════════════╝

ArangoDB is a native multi-model database supporting document,
graph, and key-value data models — all in one engine with a
single query language (AQL).

WHY MULTI-MODEL:
  Instead of running MongoDB + Neo4j + Redis separately, ArangoDB
  handles all three patterns with one database, one query language,
  and ACID transactions across models.

DATA MODELS:
  Document    JSON documents in collections (like MongoDB)
  Graph       Vertices + edges for relationship queries (like Neo4j)
  Key-Value   Fast key-based lookups (like Redis, but persistent)

AQL (ArangoDB Query Language):
  SQL-like syntax but designed for documents and graphs.
  Supports joins, graph traversals, aggregations, and full-text search.

ARCHITECTURE:
  ┌─────────────┐
  │   AQL Query │ One query language for all models
  └──────┬──────┘
         │
  ┌──────┴──────┐
  │  ArangoDB   │ Single engine
  │  ┌────────┐ │
  │  │Document│ │  JSON collections
  │  ├────────┤ │
  │  │ Graph  │ │  Vertex + Edge collections
  │  ├────────┤ │
  │  │Key-Val │ │  Fast lookups
  │  ├────────┤ │
  │  │ Search │ │  Full-text (ArangoSearch)
  │  └────────┘ │
  └─────────────┘

ARANGODB vs ALTERNATIVES:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ ArangoDB │ MongoDB  │ Neo4j    │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Documents    │ ✓        │ ✓        │ ✗        │
  │ Graphs       │ ✓        │ Limited  │ ✓        │
  │ Key-Value    │ ✓        │ ✗        │ ✗        │
  │ ACID multi   │ ✓        │ ✓ (4.0+) │ ✓        │
  │ Query lang   │ AQL      │ MQL      │ Cypher   │
  │ Clustering   │ ✓        │ ✓        │ Enterprise│
  │ License      │ Apache 2 │ SSPL     │ GPL/Comm │
  └──────────────┴──────────┴──────────┴──────────┘
EOF
}

cmd_aql() {
cat << 'EOF'
AQL QUERY LANGUAGE
====================

CRUD OPERATIONS:

  INSERT:
    INSERT { name: "Alice", age: 30, email: "alice@example.com" }
      INTO users
      RETURN NEW

  READ:
    // Get all documents
    FOR u IN users RETURN u

    // Filter
    FOR u IN users
      FILTER u.age >= 18 AND u.status == "active"
      RETURN u

    // Specific fields
    FOR u IN users
      RETURN { name: u.name, email: u.email }

  UPDATE:
    UPDATE "user123" WITH { age: 31 } IN users RETURN NEW

    // Conditional update
    FOR u IN users
      FILTER u.status == "trial" AND u.created < DATE_SUBTRACT(DATE_NOW(), 30, "days")
      UPDATE u WITH { status: "expired" } IN users

  DELETE (REMOVE):
    REMOVE "user123" IN users

    FOR u IN users
      FILTER u.status == "deleted"
      REMOVE u IN users

SORTING & PAGINATION:
  FOR u IN users
    SORT u.created DESC
    LIMIT 20, 10          // Skip 20, return 10 (page 3)
    RETURN u

AGGREGATION:
  FOR u IN users
    COLLECT status = u.status WITH COUNT INTO count
    RETURN { status, count }

  FOR o IN orders
    COLLECT AGGREGATE
      total = SUM(o.amount),
      avg = AVG(o.amount),
      count = LENGTH(1)
    RETURN { total, avg, count }

  // Group by with aggregation
  FOR o IN orders
    COLLECT month = DATE_MONTH(o.date)
    AGGREGATE revenue = SUM(o.amount)
    SORT month
    RETURN { month, revenue }

JOINS:
  // Inner join
  FOR o IN orders
    FOR u IN users
      FILTER o.user_id == u._key
      RETURN { order: o, user: u.name }

  // Subquery
  FOR u IN users
    LET orders = (
      FOR o IN orders
        FILTER o.user_id == u._key
        RETURN o
    )
    RETURN { user: u.name, orderCount: LENGTH(orders) }

FULL-TEXT SEARCH (ArangoSearch):
  FOR doc IN viewName
    SEARCH ANALYZER(doc.title IN TOKENS("search query", "text_en"), "text_en")
    SORT BM25(doc) DESC
    LIMIT 10
    RETURN doc
EOF
}

cmd_graph() {
cat << 'EOF'
GRAPH OPERATIONS
==================

GRAPH CONCEPTS:
  Vertex Collection   Nodes (e.g., users, products)
  Edge Collection     Relationships (e.g., "follows", "purchased")
  Named Graph         Groups vertex + edge collections
  Edge document       Has _from and _to fields pointing to vertices

CREATE GRAPH STRUCTURE:
  // Create vertex collection
  db._createDocumentCollection("persons")

  // Create edge collection
  db._createEdgeCollection("knows")

  // Insert vertices
  db.persons.save({ _key: "alice", name: "Alice" })
  db.persons.save({ _key: "bob", name: "Bob" })
  db.persons.save({ _key: "carol", name: "Carol" })

  // Insert edges
  db.knows.save({
    _from: "persons/alice",
    _to: "persons/bob",
    since: 2020
  })
  db.knows.save({
    _from: "persons/bob",
    _to: "persons/carol",
    since: 2022
  })

GRAPH TRAVERSAL:
  // Who does Alice know? (depth 1)
  FOR v, e IN 1..1 OUTBOUND "persons/alice" knows
    RETURN { person: v.name, since: e.since }

  // Friends of friends (depth 2)
  FOR v IN 2..2 OUTBOUND "persons/alice" knows
    RETURN DISTINCT v.name

  // All reachable people (up to depth 5)
  FOR v, e, p IN 1..5 OUTBOUND "persons/alice" knows
    RETURN { person: v.name, depth: LENGTH(p.edges) }

TRAVERSAL DIRECTIONS:
  OUTBOUND      Follow edges forward (_from → _to)
  INBOUND       Follow edges backward (_to → _from)
  ANY           Follow edges in both directions

SHORTEST PATH:
  FOR v, e IN OUTBOUND SHORTEST_PATH
    "persons/alice" TO "persons/dave"
    knows
    RETURN v.name

  // With edge weights
  FOR v, e IN OUTBOUND SHORTEST_PATH
    "persons/alice" TO "persons/dave"
    knows
    OPTIONS { weightAttribute: "distance" }
    RETURN { vertex: v.name, edge_weight: e.distance }

K SHORTEST PATHS:
  FOR p IN OUTBOUND K_SHORTEST_PATHS
    "persons/alice" TO "persons/dave"
    knows
    LIMIT 3
    RETURN p

GRAPH PATTERNS:
  // Social network: mutual friends
  FOR friend IN 1..1 OUTBOUND "persons/alice" knows
    FOR mutual IN 1..1 OUTBOUND friend knows
      FILTER mutual._id != "persons/alice"
      COLLECT person = mutual WITH COUNT INTO commonFriends
      SORT commonFriends DESC
      RETURN { person: person.name, commonFriends }

  // Recommendation: people who bought X also bought Y
  FOR buyer IN 1..1 INBOUND "products/laptop" purchased
    FOR also_bought IN 1..1 OUTBOUND buyer purchased
      FILTER also_bought._id != "products/laptop"
      COLLECT product = also_bought WITH COUNT INTO score
      SORT score DESC
      LIMIT 5
      RETURN { product: product.name, score }
EOF
}

cmd_indexing() {
cat << 'EOF'
INDEXES & PERFORMANCE
=======================

INDEX TYPES:

  Primary Index (automatic):
    Every collection has a primary index on _key.
    Unique, hash-based, cannot be removed.

  Persistent Index:
    B-tree index for range queries and sorting.
    db.users.ensureIndex({ type: "persistent", fields: ["email"] })
    db.users.ensureIndex({ type: "persistent", fields: ["age", "status"] })

  Hash Index (deprecated in 3.12+, use persistent):
    Equality lookups only.
    db.users.ensureIndex({ type: "hash", fields: ["email"], unique: true })

  Geo Index:
    Spatial queries (near, within, contains).
    db.locations.ensureIndex({ type: "geo", fields: ["lat", "lng"] })

    // Query: find nearby
    FOR loc IN locations
      FILTER GEO_DISTANCE([lng, lat], [loc.lng, loc.lat]) < 5000
      RETURN loc

  Fulltext Index (legacy, use ArangoSearch):
    db.articles.ensureIndex({ type: "fulltext", fields: ["content"], minLength: 3 })

  TTL Index:
    Auto-delete documents after expiry.
    db.sessions.ensureIndex({
      type: "ttl",
      fields: ["expireAt"],
      expireAfter: 0     // Delete when expireAt < now
    })

  ZKD Index (multi-dimensional):
    For multi-attribute range queries.
    db.events.ensureIndex({ type: "zkd", fields: ["x", "y", "z"] })

QUERY OPTIMIZATION:
  // Explain query execution plan
  db._explain("FOR u IN users FILTER u.email == 'alice@example.com' RETURN u")

  // Profile query
  db._query("FOR u IN users FILTER u.age > 25 RETURN u", {}, { profile: 2 })

PERFORMANCE TIPS:
  1. Create indexes for FILTER and SORT fields
  2. Use compound indexes for multi-field filters
  3. Avoid full collection scans (check EXPLAIN output)
  4. Use LIMIT early in traversals
  5. Use persistent indexes over hash indexes (3.12+)
  6. Monitor slow queries: /_admin/log/level

ARANGOSEARCH VIEWS:
  // Create a search view
  db._createView("articlesView", "arangosearch", {
    links: {
      articles: {
        fields: {
          title: { analyzers: ["text_en"] },
          content: { analyzers: ["text_en"] },
          tags: { analyzers: ["identity"] }
        }
      }
    }
  });

  // Search query
  FOR doc IN articlesView
    SEARCH ANALYZER(doc.title IN TOKENS("machine learning", "text_en"), "text_en")
    SORT BM25(doc) DESC
    LIMIT 10
    RETURN { title: doc.title, score: BM25(doc) }
EOF
}

cmd_admin() {
cat << 'EOF'
ADMINISTRATION
================

INSTALLATION:
  # Docker
  docker run -d --name arangodb \
    -p 8529:8529 \
    -e ARANGO_ROOT_PASSWORD=secret \
    -v arangodb_data:/var/lib/arangodb3 \
    arangodb/arangodb

  # Ubuntu/Debian
  curl -OL https://download.arangodb.com/arangodb311/DEBIAN/Release.key
  apt-key add Release.key
  echo 'deb https://download.arangodb.com/arangodb311/DEBIAN/ /' | tee /etc/apt/sources.list.d/arangodb.list
  apt update && apt install arangodb3

WEB UI:
  http://localhost:8529
  Default: root / <password set during install>
  Features: query editor, graph viewer, collection browser

ARANGOSH (JavaScript shell):
  arangosh --server.endpoint tcp://localhost:8529

  db._databases()                     // List databases
  db._createDatabase("mydb")          // Create database
  db._useDatabase("mydb")             // Switch database
  db._collections()                   // List collections
  db._create("users")                 // Create collection
  db.users.count()                    // Document count
  db.users.save({ name: "Alice" })    // Insert document

BACKUP:
  # Hot backup (Enterprise)
  arangodump --output-directory dump --server.database mydb

  # Restore
  arangorestore --input-directory dump --server.database mydb

  # Selective backup
  arangodump --collection users --collection orders --output-directory dump

CLUSTERING:
  Coordinator    Routes queries (stateless, scale horizontally)
  DB-Server      Stores data (sharded, replicated)
  Agent          Consensus (Raft-based, typically 3)

  Production: 3 agents + 2 coordinators + 3 DB-servers (minimum)

  Sharding:
    db._create("users", { numberOfShards: 3, replicationFactor: 2 })
    // 3 shards, each replicated to 2 servers

MONITORING:
  /_admin/statistics         Server stats
  /_admin/metrics            Prometheus-format metrics
  /_api/cluster/health       Cluster health (cluster mode)

  Key metrics:
  - arangodb_requests_total
  - arangodb_collection_lock_acquisition_time
  - arangodb_aql_slow_query_total
  - rocksdb_block_cache_usage

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
ArangoDB - Multi-Model Database Reference

Commands:
  intro      Overview, multi-model architecture
  aql        AQL query language (CRUD, joins, aggregation)
  graph      Graph traversal, shortest path, patterns
  indexing   Index types, ArangoSearch, performance
  admin      Installation, backup, clustering, monitoring

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  aql)      cmd_aql ;;
  graph)    cmd_graph ;;
  indexing) cmd_indexing ;;
  admin)    cmd_admin ;;
  help|*)   show_help ;;
esac
