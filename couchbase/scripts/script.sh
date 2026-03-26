#!/bin/bash
# Couchbase - Distributed Document Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              COUCHBASE REFERENCE                            ║
║          Distributed JSON Document Database                 ║
╚══════════════════════════════════════════════════════════════╝

Couchbase is a distributed NoSQL document database with SQL-like
query language (N1QL), built-in caching, full-text search, and
mobile sync.

KEY FEATURES:
  Document store   JSON documents with flexible schema
  N1QL (SQL++)     SQL-like query language for JSON
  Key-value        Sub-millisecond key-based lookups
  Full-text search Built-in Bleve search engine
  Eventing         Server-side event processing
  Mobile sync      Couchbase Lite + Sync Gateway
  Caching          Integrated memcached protocol

ARCHITECTURE:
  Cluster of nodes, each running services:
  ┌─────────────────────────────────────┐
  │           Couchbase Cluster         │
  ├──────┬──────┬──────┬──────┬────────┤
  │ Data │Query │Index │Search│Eventing│
  │Service│Service│Service│Service│Service│
  └──────┴──────┴──────┴──────┴────────┘

  Data distributed via vBuckets (1024 per bucket).
  Auto-rebalance when nodes join/leave.

COUCHBASE vs MONGODB vs REDIS:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │Couchbase │ MongoDB  │ Redis    │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Model        │ Document │ Document │ Key-value│
  │ SQL-like     │ N1QL     │ MQL      │ No       │
  │ Caching      │ Built-in │ No       │ Primary  │
  │ Full-text    │ Built-in │ Atlas    │ RediSearch│
  │ Mobile sync  │ Yes      │ Realm    │ No       │
  │ Sub-ms reads │ Yes      │ No       │ Yes      │
  │ Multi-model  │ Yes      │ Limited  │ Yes      │
  └──────────────┴──────────┴──────────┴──────────┘
EOF
}

cmd_n1ql() {
cat << 'EOF'
N1QL (SQL++ for JSON)
=======================

N1QL lets you query JSON documents with familiar SQL syntax.

SELECT:
  SELECT * FROM `travel-sample` WHERE type = "hotel" LIMIT 10;

  SELECT name, city, avg_rating
  FROM `travel-sample`
  WHERE type = "hotel" AND country = "France"
  ORDER BY avg_rating DESC
  LIMIT 20;

NESTED JSON:
  SELECT name, address.city, address.state
  FROM `users`
  WHERE address.zip = "94105";

  -- Array operations
  SELECT name, ARRAY_LENGTH(reviews) AS review_count
  FROM `products`
  WHERE ANY r IN reviews SATISFIES r.rating >= 4 END;

  -- Unnest (flatten arrays)
  SELECT p.name, r.rating, r.text
  FROM `products` p UNNEST p.reviews r
  WHERE r.rating = 5;

INSERT:
  INSERT INTO `users` (KEY, VALUE)
  VALUES ("user::1001", {
    "type": "user",
    "name": "Alice",
    "email": "alice@example.com",
    "created": NOW_STR()
  });

  -- Returning
  INSERT INTO `users` (KEY, VALUE)
  VALUES ("user::1002", {"type":"user","name":"Bob"})
  RETURNING *;

UPDATE:
  UPDATE `users`
  SET email = "newemail@example.com",
      updated = NOW_STR()
  WHERE META().id = "user::1001";

  -- Array append
  UPDATE `products`
  SET reviews = ARRAY_APPEND(reviews, {"rating":5,"text":"Great!"})
  WHERE META().id = "product::42";

DELETE:
  DELETE FROM `users` WHERE type = "inactive";
  DELETE FROM `users` WHERE META().id = "user::1001";

MERGE (upsert logic):
  MERGE INTO `target` t
  USING `source` s ON t.id = s.id
  WHEN MATCHED THEN UPDATE SET t.name = s.name
  WHEN NOT MATCHED THEN INSERT (KEY s.id, VALUE s);

AGGREGATION:
  SELECT country, COUNT(*) AS hotels, AVG(avg_rating) AS avg_rating
  FROM `travel-sample`
  WHERE type = "hotel"
  GROUP BY country
  HAVING COUNT(*) > 10
  ORDER BY avg_rating DESC;

JOINS:
  SELECT u.name, o.total, o.date
  FROM `orders` o
  JOIN `users` u ON KEYS o.user_id
  WHERE o.total > 100;

  -- ANSI JOIN
  SELECT u.name, o.total
  FROM `users` u
  JOIN `orders` o ON u.id = o.user_id
  WHERE u.country = "US";

INDEXES:
  CREATE INDEX idx_type ON `travel-sample`(type);
  CREATE INDEX idx_city ON `travel-sample`(city) WHERE type = "hotel";
  CREATE INDEX idx_email ON `users`(email);

  -- Composite
  CREATE INDEX idx_country_rating ON `travel-sample`(country, avg_rating DESC)
  WHERE type = "hotel";

  -- Array index
  CREATE INDEX idx_reviews ON `products`(DISTINCT ARRAY r.rating FOR r IN reviews END);

  -- Covering index (no doc fetch needed)
  CREATE INDEX idx_covering ON `users`(name, email, city);
EOF
}

cmd_sdk() {
cat << 'EOF'
SDK & KEY-VALUE OPERATIONS
============================

Key-value operations bypass N1QL for sub-millisecond access.

NODE.JS SDK:
  const couchbase = require("couchbase");

  const cluster = await couchbase.connect("couchbase://localhost", {
    username: "admin",
    password: "password"
  });

  const bucket = cluster.bucket("myapp");
  const collection = bucket.defaultCollection();

  // Get
  const result = await collection.get("user::1001");
  console.log(result.content);

  // Insert
  await collection.insert("user::1002", {
    type: "user", name: "Bob", email: "bob@example.com"
  });

  // Upsert (insert or replace)
  await collection.upsert("user::1001", {
    type: "user", name: "Alice Updated"
  });

  // Replace (must exist)
  await collection.replace("user::1001", newDoc);

  // Remove
  await collection.remove("user::1001");

  // N1QL query
  const query = await cluster.query(
    "SELECT * FROM `myapp` WHERE type = $type LIMIT $limit",
    { parameters: { type: "user", limit: 10 } }
  );

SUB-DOCUMENT (partial read/write):
  // Get specific fields (no full doc transfer)
  const result = await collection.lookupIn("user::1001", [
    couchbase.LookupInSpec.get("name"),
    couchbase.LookupInSpec.get("address.city"),
    couchbase.LookupInSpec.exists("premium"),
  ]);

  // Mutate specific fields
  await collection.mutateIn("user::1001", [
    couchbase.MutateInSpec.upsert("last_login", new Date().toISOString()),
    couchbase.MutateInSpec.increment("login_count", 1),
    couchbase.MutateInSpec.arrayAppend("tags", "active"),
  ]);

ATOMIC COUNTERS:
  // Binary counter (fast increment)
  const counter = bucket.defaultCollection().binary();
  await counter.increment("page_views::home", 1, { initial: 0 });

DOCUMENT EXPIRY (TTL):
  await collection.upsert("session::abc", data, {
    expiry: 3600  // Expires in 1 hour
  });

  // Touch (reset TTL without modifying)
  await collection.touch("session::abc", 3600);

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Couchbase - Distributed Document Database Reference

Commands:
  intro    Overview, architecture, comparison
  n1ql     SQL++ queries, joins, indexes, aggregation
  sdk      Key-value ops, sub-document, counters, TTL

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  n1ql)  cmd_n1ql ;;
  sdk)   cmd_sdk ;;
  help|*) show_help ;;
esac
