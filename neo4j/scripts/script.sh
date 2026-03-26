#!/bin/bash
# Neo4j - Graph Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              NEO4J REFERENCE                                ║
║          Native Graph Database                              ║
╚══════════════════════════════════════════════════════════════╝

Neo4j is the most popular graph database. It stores data as
nodes, relationships, and properties — ideal for connected
data like social networks, recommendations, and fraud detection.

GRAPH DATA MODEL:
  (Person {name:"Alice"})
       |
    [:KNOWS {since:2020}]
       |
  (Person {name:"Bob"})
       |
    [:WORKS_AT]
       |
  (Company {name:"Acme"})

WHEN TO USE A GRAPH DB:
  ✓ Social networks (friends of friends)
  ✓ Recommendation engines
  ✓ Fraud detection (ring patterns)
  ✓ Knowledge graphs
  ✓ Network/IT infrastructure mapping
  ✓ Supply chain / logistics
  ✗ Simple CRUD apps (use PostgreSQL)
  ✗ Time-series data (use TimescaleDB)
  ✗ Document storage (use MongoDB)

INSTALL:
  docker run -d -p 7474:7474 -p 7687:7687 \
    -e NEO4J_AUTH=neo4j/password \
    neo4j:5
  # Browser: http://localhost:7474
EOF
}

cmd_cypher() {
cat << 'EOF'
CYPHER QUERY LANGUAGE
=======================

CREATE:
  // Create node
  CREATE (p:Person {name: "Alice", age: 30})

  // Create with relationship
  CREATE (a:Person {name: "Alice"})-[:KNOWS {since: 2020}]->(b:Person {name: "Bob"})

  // Merge (create if not exists)
  MERGE (p:Person {name: "Alice"})
  ON CREATE SET p.created = datetime()
  ON MATCH SET p.lastSeen = datetime()

READ:
  // Find by property
  MATCH (p:Person {name: "Alice"}) RETURN p

  // Find with condition
  MATCH (p:Person) WHERE p.age > 25 RETURN p.name, p.age

  // Traverse relationships
  MATCH (a:Person)-[:KNOWS]->(b:Person) RETURN a.name, b.name

  // Friends of friends
  MATCH (a:Person {name: "Alice"})-[:KNOWS*2]->(fof:Person)
  WHERE fof <> a
  RETURN DISTINCT fof.name

  // Shortest path
  MATCH path = shortestPath(
    (a:Person {name: "Alice"})-[:KNOWS*]-(b:Person {name: "Dave"})
  )
  RETURN path, length(path)

  // Pattern matching
  MATCH (p:Person)-[:WORKS_AT]->(c:Company {name: "Acme"})
  RETURN p.name, c.name

UPDATE:
  MATCH (p:Person {name: "Alice"})
  SET p.age = 31, p.email = "alice@example.com"

  // Add label
  MATCH (p:Person {name: "Alice"})
  SET p:Employee

  // Remove property
  MATCH (p:Person {name: "Alice"})
  REMOVE p.email

DELETE:
  // Delete node (must have no relationships)
  MATCH (p:Person {name: "Alice"}) DELETE p

  // Delete with relationships
  MATCH (p:Person {name: "Alice"}) DETACH DELETE p

  // Delete relationship only
  MATCH (a)-[r:KNOWS]->(b) WHERE a.name = "Alice" DELETE r

AGGREGATIONS:
  MATCH (p:Person)-[:KNOWS]->(friend)
  RETURN p.name, count(friend) AS friendCount
  ORDER BY friendCount DESC LIMIT 10

  MATCH (p:Person)
  RETURN avg(p.age), min(p.age), max(p.age)
EOF
}

cmd_advanced() {
cat << 'EOF'
INDEXES, CONSTRAINTS & GRAPH ALGORITHMS
==========================================

INDEXES:
  // B-tree index
  CREATE INDEX person_name FOR (p:Person) ON (p.name)

  // Composite index
  CREATE INDEX FOR (p:Person) ON (p.name, p.age)

  // Full-text search index
  CREATE FULLTEXT INDEX personSearch FOR (p:Person) ON EACH [p.name, p.bio]
  CALL db.index.fulltext.queryNodes("personSearch", "alice developer")

  // Show indexes
  SHOW INDEXES

CONSTRAINTS:
  // Unique
  CREATE CONSTRAINT FOR (p:Person) REQUIRE p.email IS UNIQUE

  // Exists (enterprise)
  CREATE CONSTRAINT FOR (p:Person) REQUIRE p.name IS NOT NULL

  // Node key (enterprise)
  CREATE CONSTRAINT FOR (p:Person) REQUIRE (p.firstName, p.lastName) IS NODE KEY

GRAPH DATA SCIENCE (GDS):
  // PageRank
  CALL gds.pageRank.stream('myGraph')
  YIELD nodeId, score
  RETURN gds.util.asNode(nodeId).name, score
  ORDER BY score DESC LIMIT 10

  // Community detection (Louvain)
  CALL gds.louvain.stream('myGraph')
  YIELD nodeId, communityId
  RETURN gds.util.asNode(nodeId).name, communityId

  // Similarity
  CALL gds.nodeSimilarity.stream('myGraph')
  YIELD node1, node2, similarity
  RETURN gds.util.asNode(node1).name,
         gds.util.asNode(node2).name, similarity

PYTHON DRIVER:
  pip install neo4j

  from neo4j import GraphDatabase
  driver = GraphDatabase.driver("bolt://localhost:7687",
    auth=("neo4j", "password"))

  with driver.session() as session:
      result = session.run(
          "MATCH (p:Person)-[:KNOWS]->(f) "
          "WHERE p.name = $name RETURN f.name",
          name="Alice"
      )
      for record in result:
          print(record["f.name"])

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Neo4j - Graph Database Reference

Commands:
  intro      Graph model, use cases
  cypher     Cypher queries, CRUD, paths
  advanced   Indexes, constraints, GDS, Python

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  cypher)   cmd_cypher ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
