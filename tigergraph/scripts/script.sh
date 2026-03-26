#!/bin/bash
# TigerGraph - Distributed Graph Analytics Platform Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TIGERGRAPH REFERENCE                           ║
║          Distributed Graph Analytics Platform               ║
╚══════════════════════════════════════════════════════════════╝

TigerGraph is a native parallel graph database designed for
real-time deep-link analytics on massive datasets. It supports
graphs with 100+ billion edges and sub-second queries.

TIGERGRAPH vs NEO4J:
  ┌──────────────────┬──────────────┬──────────────┐
  │ Feature          │ TigerGraph   │ Neo4j        │
  ├──────────────────┼──────────────┼──────────────┤
  │ Query language   │ GSQL         │ Cypher       │
  │ Scale            │ 100B+ edges  │ ~10B edges   │
  │ Architecture     │ MPP parallel │ Single-server│
  │ Deep traversal   │ 10+ hops fast│ 3-4 hops     │
  │ Real-time ingest │ Yes (native) │ Limited      │
  │ ML integration   │ GDS library  │ GDS plugin   │
  │ Pricing          │ Enterprise   │ Community/Ent│
  │ Best for         │ Fraud/supply │ Knowledge    │
  │                  │ chain/IoT    │ graphs       │
  └──────────────────┴──────────────┴──────────────┘

USE CASES:
  Fraud detection     Real-time transaction patterns
  Supply chain        Multi-hop dependency tracking
  Customer 360        Entity resolution across sources
  Recommendation      Collaborative filtering at scale
  Network analytics   Telecom/IT infrastructure mapping
  Anti-money laundering Transaction flow analysis

ARCHITECTURE:
  REST API ←→ RESTPP (query engine)
                ↕
  GSQL Shell ←→ GSE (Graph Storage Engine)
                ↕
              GLE (Graph Learning Engine)
                ↕
              Dictionary (schema store)

INSTALL:
  # Docker
  docker run -d -p 14240:14240 -p 9000:9000 \
    --name tigergraph tigergraph/tigergraph:latest

  # GraphStudio UI: http://localhost:14240
  # REST API: http://localhost:9000
  # Default: tigergraph/tigergraph
EOF
}

cmd_gsql() {
cat << 'EOF'
GSQL QUERY LANGUAGE
=====================

SCHEMA DEFINITION:
  CREATE VERTEX Person (
    PRIMARY_ID id STRING,
    name STRING,
    age INT,
    created_at DATETIME
  )

  CREATE VERTEX Company (
    PRIMARY_ID id STRING,
    name STRING,
    industry STRING
  )

  CREATE DIRECTED EDGE works_at (
    FROM Person, TO Company,
    title STRING,
    since DATETIME
  )

  CREATE UNDIRECTED EDGE knows (
    FROM Person, TO Person,
    strength FLOAT
  )

  CREATE GRAPH social (Person, Company, works_at, knows)

DATA LOADING:
  CREATE LOADING JOB load_people FOR GRAPH social {
    DEFINE FILENAME people_file;
    LOAD people_file TO VERTEX Person VALUES (
      $"id", $"name", $"age", $"created"
    ) USING SEPARATOR=",", HEADER="true";
  }
  RUN LOADING JOB load_people USING people_file="people.csv"

  # REST API loading
  curl -X POST 'http://localhost:9000/ddl/social' \
    -d '{"vertices":{"Person":{"p1":{"name":{"value":"Alice"},"age":{"value":30}}}}}'

QUERIES:
  # Interpreted query (ad-hoc)
  INTERPRET QUERY () FOR GRAPH social {
    start = {Person.*};
    result = SELECT p FROM start:p
             WHERE p.age > 25
             ORDER BY p.age DESC
             LIMIT 10;
    PRINT result;
  }

  # Installed query (compiled, faster)
  CREATE QUERY find_friends(VERTEX<Person> person, INT depth) FOR GRAPH social {
    OrAccum @visited = false;
    start = {person};
    FOREACH i IN RANGE[0, depth-1] DO
      start = SELECT t FROM start:s -(knows:e)- Person:t
              WHERE t.@visited == false
              POST-ACCUM t.@visited = true;
    END;
    PRINT start;
  }
  INSTALL QUERY find_friends

  # PageRank
  CREATE QUERY pagerank(FLOAT damping = 0.85, INT max_iter = 20, FLOAT tolerance = 0.001) FOR GRAPH social {
    MaxAccum<FLOAT> @@max_diff = 999;
    SumAccum<FLOAT> @received_score = 0;
    SumAccum<FLOAT> @score = 1.0;

    all_v = {Person.*};
    WHILE @@max_diff > tolerance LIMIT max_iter DO
      @@max_diff = 0;
      all_v = SELECT v FROM all_v:v -(knows:e)- :t
              ACCUM t.@received_score += v.@score / v.outdegree()
              POST-ACCUM
                FLOAT old = v.@score,
                v.@score = (1 - damping) + damping * v.@received_score,
                v.@received_score = 0,
                @@max_diff += abs(v.@score - old);
    END;
    PRINT all_v[all_v.@score];
  }
EOF
}

cmd_api() {
cat << 'EOF'
REST API & PYTHON SDK
=======================

REST API:
  # Get vertices
  curl 'http://localhost:9000/graph/social/vertices/Person?limit=10'

  # Get specific vertex
  curl 'http://localhost:9000/graph/social/vertices/Person/p001'

  # Get edges
  curl 'http://localhost:9000/graph/social/edges/Person/p001/knows'

  # Run installed query
  curl 'http://localhost:9000/query/social/find_friends?person=p001&depth=3'

  # Upsert vertex
  curl -X POST 'http://localhost:9000/graph/social' \
    -d '{"vertices":{"Person":{"p002":{"name":{"value":"Bob"},"age":{"value":25}}}}}'

  # Upsert edge
  curl -X POST 'http://localhost:9000/graph/social' \
    -d '{"edges":{"Person":{"p001":{"knows":{"Person":{"p002":{"strength":{"value":0.9}}}}}}}}'

  # Delete vertex
  curl -X DELETE 'http://localhost:9000/graph/social/vertices/Person/p001'

  # Get statistics
  curl 'http://localhost:9000/statistics/social'

  # Authentication (token-based)
  curl -X POST 'http://localhost:9000/requesttoken' \
    -d '{"graph":"social","lifetime":"3600"}' \
    -u 'tigergraph:tigergraph'
  # Use token: -H "Authorization: Bearer <token>"

PYTHON SDK (pyTigerGraph):
  pip install pyTigerGraph

  import pyTigerGraph as tg

  conn = tg.TigerGraphConnection(
      host="http://localhost",
      graphname="social",
      username="tigergraph",
      password="tigergraph"
  )
  conn.apiToken = conn.getToken(conn.createSecret())

  # Get vertices
  people = conn.getVertices("Person", limit=10)

  # Run query
  result = conn.runInstalledQuery("find_friends", {"person": "p001", "depth": 3})

  # Upsert
  conn.upsertVertex("Person", "p003", {"name": "Carol", "age": 28})
  conn.upsertEdge("Person", "p001", "knows", "Person", "p003", {"strength": 0.8})

  # Get vertex count
  count = conn.getVertexCount("Person")

  # GDS (Graph Data Science)
  feats = conn.gds.featurizer()
  feats.runAlgorithm("tg_pagerank", params={"v_type": "Person", "e_type": "knows"})

GRAPHSTUDIO:
  # Browser-based IDE at port 14240
  # Features:
  - Visual schema designer (drag-and-drop)
  - Query editor with syntax highlighting
  - Data loading wizard
  - Graph exploration (click to traverse)
  - Built-in analytics dashboard

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
TigerGraph - Distributed Graph Analytics Reference

Commands:
  intro    Architecture, vs Neo4j, use cases
  gsql     Schema, loading, queries, PageRank
  api      REST API, pyTigerGraph SDK, GraphStudio

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  gsql)  cmd_gsql ;;
  api)   cmd_api ;;
  help|*) show_help ;;
esac
