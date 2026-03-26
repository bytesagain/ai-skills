#!/bin/bash
# Dgraph - Distributed Graph Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              DGRAPH REFERENCE                               ║
║          Native GraphQL Graph Database                      ║
╚══════════════════════════════════════════════════════════════╝

Dgraph is a horizontally scalable, distributed graph database
with native GraphQL support. It uses a modified version of
GraphQL for queries (DQL/GraphQL+-) and supports GraphQL APIs.

KEY FEATURES:
  Native graph     Not a graph layer on top of another DB
  GraphQL API      Auto-generated from schema
  DQL              Dgraph Query Language (graph traversals)
  Distributed      Sharded across multiple nodes
  ACID             Full ACID transactions
  Geo queries      Geospatial indexing and queries

ARCHITECTURE:
  Zero     Cluster coordinator (like ZooKeeper)
  Alpha    Data server (stores predicates/edges)
  Ratel    Web UI for queries and schema (optional)

  Data model:
  - Everything is a triple: <subject> <predicate> <object>
  - Subjects have UIDs (unique IDs)
  - Predicates are typed (string, int, float, datetime, geo, etc.)
  - Objects can be values or other nodes (edges)

DGRAPH vs NEO4J vs ARANGODB:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Dgraph   │ Neo4j    │ ArangoDB │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Query lang   │ DQL/GQL  │ Cypher   │ AQL      │
  │ Distributed  │ Native   │ Enterprise│ Yes     │
  │ GraphQL      │ Native   │ Plugin   │ Foxx     │
  │ ACID         │ Yes      │ Yes      │ Yes      │
  │ Multi-model  │ No       │ No       │ Yes      │
  │ License      │ Apache2  │ GPL/Comm │ Apache2  │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Docker (quickstart)
  docker run -d -p 8080:8080 -p 9080:9080 dgraph/standalone:latest

  # Docker Compose (production)
  # See dgraph.io/docs for full compose file
EOF
}

cmd_schema() {
cat << 'EOF'
SCHEMA & DATA
===============

DQL SCHEMA:
  # Predicate types
  name: string @index(term, fulltext) .
  age: int @index(int) .
  email: string @index(exact) @upsert .
  friends: [uid] @reverse @count .
  location: geo @index(geo) .
  created_at: datetime @index(hour) .
  bio: string @lang .
  score: float .
  active: bool @index(bool) .
  avatar: string .

  # Types (optional but recommended)
  type Person {
      name
      age
      email
      friends
      location
      created_at
      active
  }

INDEX TYPES:
  string:    exact, hash, term, fulltext, trigram
  int:       int
  float:     float
  bool:      bool
  datetime:  year, month, day, hour
  geo:       geo

  exact     Exact match, inequality (=, <, >)
  hash      Only exact match (faster than exact)
  term      Word-level search (allofterms, anyofterms)
  fulltext  Full-text search with stemming
  trigram   Regular expression matching

MUTATIONS (Insert/Update):
  # Insert (set)
  {
    set {
      _:alice <name> "Alice" .
      _:alice <age> "30" .
      _:alice <email> "alice@example.com" .
      _:alice <dgraph.type> "Person" .
      _:bob <name> "Bob" .
      _:bob <age> "25" .
      _:bob <dgraph.type> "Person" .
      _:alice <friends> _:bob .
    }
  }

  # JSON mutation
  {
    "set": [
      {
        "uid": "_:alice",
        "dgraph.type": "Person",
        "name": "Alice",
        "age": 30,
        "friends": [{"uid": "_:bob"}]
      },
      {
        "uid": "_:bob",
        "dgraph.type": "Person",
        "name": "Bob",
        "age": 25
      }
    ]
  }

  # Delete
  {
    delete {
      <0x1> <friends> <0x2> .    # Delete edge
      <0x1> <name> * .           # Delete all values of predicate
      <0x1> * * .                # Delete node entirely
    }
  }

  # Upsert (query + mutate atomically)
  upsert {
    query {
      user as var(func: eq(email, "alice@example.com"))
    }
    mutation {
      set {
        uid(user) <name> "Alice Updated" .
        uid(user) <age> "31" .
      }
    }
  }
EOF
}

cmd_queries() {
cat << 'EOF'
DQL QUERIES
=============

BASIC QUERY:
  {
    people(func: has(name), first: 10) {
      uid
      name
      age
      email
    }
  }

FILTERS:
  {
    adults(func: ge(age, 18)) {
      name
      age
    }
  }

  # Filter functions:
  eq(pred, val)       # Equal
  ge(pred, val)       # Greater or equal
  gt(pred, val)       # Greater than
  le(pred, val)       # Less or equal
  lt(pred, val)       # Less than
  has(pred)           # Has predicate
  type(TypeName)      # Has type

  # String search
  allofterms(name, "Alice Bob")     # All terms present
  anyofterms(name, "Alice Bob")     # Any term present
  regexp(name, /ali.*/i)            # Regex

  # Combined filters
  {
    q(func: type(Person)) @filter(ge(age, 18) AND lt(age, 65)) {
      name
      age
    }
  }

GRAPH TRAVERSAL:
  {
    alice(func: eq(name, "Alice")) {
      name
      friends {              # Follow edge
        name
        age
        friends {            # 2 hops deep
          name
        }
      }
    }
  }

  # Reverse edges
  {
    bob(func: eq(name, "Bob")) {
      name
      ~friends {             # Who has Bob as friend?
        name
      }
    }
  }

PAGINATION:
  {
    people(func: has(name), first: 10, offset: 20, orderasc: name) {
      name
      age
    }
  }

AGGREGATION:
  {
    stats(func: type(Person)) {
      count(uid)
      min(age)
      max(age)
      avg(age)
      sum(age)
    }
  }

  # Group by
  {
    byCity(func: has(city)) @groupby(city) {
      count(uid)
    }
  }

VARIABLES & CASCADING:
  {
    var(func: eq(name, "Alice")) {
      friends {
        fof as friends
      }
    }
    friendsOfFriends(func: uid(fof)) {
      name
    }
  }

SHORTEST PATH:
  {
    path as shortest(from: 0x1, to: 0x5) {
      friends
    }
    result(func: uid(path)) {
      name
    }
  }

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Dgraph - Distributed Graph Database Reference

Commands:
  intro     Overview, architecture, comparison
  schema    Predicates, types, indexes, mutations
  queries   DQL queries, filters, traversals, paths

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  schema)  cmd_schema ;;
  queries) cmd_queries ;;
  help|*)  show_help ;;
esac
