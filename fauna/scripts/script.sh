#!/bin/bash
# Fauna - Serverless Document-Relational Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FAUNA REFERENCE                                ║
║          Serverless Document-Relational Database             ║
╚══════════════════════════════════════════════════════════════╝

Fauna is a serverless, document-relational database with native
GraphQL support and strong consistency. No infrastructure to
manage — just an API.

KEY FEATURES:
  Serverless       No provisioning, auto-scales
  Document-relational  Documents + relations + joins
  ACID             Fully serializable transactions
  Global           Multi-region with strong consistency
  FQL              Functional Query Language
  GraphQL          Native GraphQL API
  Temporal         Every document has history
  Multi-tenancy    Built-in child databases

FAUNA vs MONGODB vs DYNAMODB:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Fauna    │ MongoDB  │ DynamoDB │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Model        │ Doc+Rel  │ Document │ Key-Value│
  │ Query        │ FQL      │ MQL      │ PartiQL  │
  │ Consistency  │ Strong   │ Tunable  │ Eventual*│
  │ Relations    │ Native   │ $lookup  │ No       │
  │ Transactions │ ACID     │ ACID     │ Limited  │
  │ Serverless   │ Yes      │ Atlas    │ Yes      │
  │ GraphQL      │ Native   │ No       │ No       │
  │ History      │ Built-in │ No       │ Streams  │
  └──────────────┴──────────┴──────────┴──────────┘
  * DynamoDB has strong consistency option per-read

PRICING:
  Free tier: 100K read ops, 50K write ops, 1GB storage
  Pay-as-you-go: per operation + storage
EOF
}

cmd_fql() {
cat << 'EOF'
FQL v10 (Fauna Query Language)
================================

COLLECTIONS:
  // Create collection
  Collection.create({ name: "users" })
  Collection.create({
    name: "posts",
    indexes: {
      byAuthor: {
        terms: [{ field: "authorId" }],
        values: [{ field: "createdAt", order: "desc" }]
      }
    }
  })

DOCUMENTS:
  // Create
  users.create({
    name: "Alice",
    email: "alice@example.com",
    age: 30,
    tags: ["developer", "python"]
  })

  // Read by ID
  users.byId("370234567890123456")

  // Update
  users.byId("370234567890123456")!.update({
    age: 31,
    tags: ["developer", "python", "rust"]
  })

  // Delete
  users.byId("370234567890123456")!.delete()

QUERIES:
  // All documents
  users.all()

  // Filter
  users.where(.age > 25)
  users.where(.email == "alice@example.com")
  users.where(.tags.includes("python"))

  // Index query
  posts.byAuthor("user123")

  // Paginate
  users.all().pageSize(20)
  users.all().paginate("after_cursor")

  // Order
  users.all().order(.age)
  users.all().order(desc(.createdAt))

  // Map/project
  users.all().map(u => {
    name: u.name,
    email: u.email
  })

  // First/count
  users.where(.age > 25).first()
  users.all().count()

RELATIONS:
  // Define relation in collection schema
  Collection.create({
    name: "posts",
    fields: {
      author: { type: "Ref", collection: "users" }
    }
  })

  // Create with relation
  posts.create({
    title: "Hello World",
    author: users.byId("370234567890123456")
  })

  // Follow relation (join)
  let post = posts.byId("123")!
  post.author.name   // Follows the reference

  // Reverse lookup
  posts.where(.author == users.byId("370234567890123456"))

TRANSACTIONS:
  // Everything in FQL is transactional
  // Multi-document atomic operations
  let user = users.create({ name: "Bob", balance: 1000 })
  let order = orders.create({ userId: user.id, total: 50 })
  users.byId(user.id)!.update({ balance: user.balance - 50 })
  // All or nothing — fully ACID
EOF
}

cmd_tools() {
cat << 'EOF'
TOOLS & SDKS
==============

FAUNA SHELL:
  npm install -g fauna-shell
  fauna login
  fauna eval "users.all()"
  fauna eval --database myapp "users.all()"

JAVASCRIPT SDK:
  npm install fauna

  import { Client, fql } from "fauna";
  const client = new Client({ secret: "fn..." });

  // Query
  const result = await client.query(
    fql`users.where(.age > ${25})`
  );
  console.log(result.data);

  // Create
  await client.query(
    fql`users.create({
      name: ${name},
      email: ${email}
    })`
  );

  // Transaction
  await client.query(fql`
    let user = users.byId(${userId})!
    let newBalance = user.balance - ${amount}
    if (newBalance < 0) abort("Insufficient funds")
    user.update({ balance: newBalance })
    orders.create({ userId: ${userId}, amount: ${amount} })
  `);

PYTHON SDK:
  pip install fauna
  from fauna import fql
  from fauna.client import Client

  client = Client(secret="fn...")
  result = client.query(fql("users.all()"))

GRAPHQL:
  # Upload schema
  fauna schema push

  # Schema (schema.gql)
  type User {
    name: String!
    email: String! @unique
    posts: [Post!] @relation
  }
  type Post {
    title: String!
    body: String!
    author: User!
  }
  type Query {
    allUsers: [User!]!
    userByEmail(email: String!): User
  }

  # Query
  query {
    allUsers {
      name
      posts {
        title
      }
    }
  }

TEMPORAL (document history):
  // Every document change is recorded
  users.byId("123")!.events()
  // Returns: create, update, delete events with timestamps

  // Point-in-time query
  users.byId("123")!.at("2026-03-24T00:00:00Z")

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Fauna - Serverless Document-Relational Database Reference

Commands:
  intro    Overview, comparison
  fql      FQL v10, CRUD, relations, transactions
  tools    Shell, JS/Python SDKs, GraphQL, temporal

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  fql)   cmd_fql ;;
  tools) cmd_tools ;;
  help|*) show_help ;;
esac
