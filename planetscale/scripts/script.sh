#!/bin/bash
# PlanetScale - Serverless MySQL Platform Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PLANETSCALE REFERENCE                          ║
║          Serverless MySQL with Branching                    ║
╚══════════════════════════════════════════════════════════════╝

PlanetScale is a serverless MySQL-compatible database platform
built on Vitess (the same technology that scaled YouTube's DB).
It provides git-like branching for database schema changes.

KEY FEATURES:
  Vitess-powered   Battle-tested at YouTube scale
  Branching        Git-like schema change workflow
  Deploy requests  Review schema changes before deploying
  Non-blocking     Schema changes without downtime
  Serverless       Auto-scales, per-request pricing
  Sharding         Horizontal sharding via Vitess
  Insights         Query performance analytics
  Boost            Query caching layer

PLANETSCALE vs NEON vs RDS:
  ┌──────────────┬────────────┬──────────┬──────────┐
  │ Feature      │PlanetScale │ Neon     │ RDS      │
  ├──────────────┼────────────┼──────────┼──────────┤
  │ Engine       │ MySQL      │ Postgres │ Multiple │
  │ Branching    │ Schema     │ Full data│ Snapshot │
  │ Sharding     │ Vitess     │ No       │ No       │
  │ Scale to 0   │ Yes        │ Yes      │ No       │
  │ FK support   │ No*        │ Yes      │ Yes      │
  │ Pricing      │ Per-read   │ Per-use  │ Per-hour │
  └──────────────┴────────────┴──────────┴──────────┘
  * PlanetScale doesn't support foreign key constraints
    (Vitess limitation — enforce in application layer)

CONNECT:
  mysql -h aws.connect.psdb.cloud -u username \
    --password=pscale_pw_xxx -D mydb --ssl-mode=VERIFY_IDENTITY
EOF
}

cmd_branching() {
cat << 'EOF'
BRANCHING & DEPLOY REQUESTS
==============================

DATABASE BRANCHING:
  # CLI
  pscale branch create mydb feature-users
  pscale branch list mydb
  pscale branch delete mydb feature-users

  # Connect to branch
  pscale shell mydb feature-users

  # Or get connection string
  pscale connect mydb feature-users --port 3309

WORKFLOW:
  1. Create branch from main
     pscale branch create mydb add-orders-table

  2. Apply schema changes on branch
     pscale shell mydb add-orders-table
     > CREATE TABLE orders (...);
     > ALTER TABLE users ADD COLUMN order_count INT DEFAULT 0;

  3. Create deploy request (like a PR)
     pscale deploy-request create mydb add-orders-table

  4. Review diff (shows exact schema changes)
     pscale deploy-request diff mydb 42

  5. Deploy to production (non-blocking!)
     pscale deploy-request deploy mydb 42

     # Schema change runs online — zero downtime
     # Uses Vitess Online DDL (gh-ost or pt-osc under the hood)

NON-BLOCKING SCHEMA CHANGES:
  # These run online, no locking:
  ALTER TABLE users ADD COLUMN bio TEXT;
  ALTER TABLE orders ADD INDEX idx_user (user_id);
  ALTER TABLE products MODIFY COLUMN price DECIMAL(12,2);

  # PlanetScale handles:
  # - Shadow table creation
  # - Row-by-row copy
  # - Cutover with minimal lock time
  # - Automatic rollback on failure

SAFE MIGRATIONS:
  # Deploy request shows:
  - Schema diff (what changes)
  - Lint warnings (potential issues)
  - Deployment plan (how it will execute)
  - Estimated time

  # Auto-revert: if migration fails, auto-reverts
  # No more "ALTER TABLE locked my production for 2 hours"
EOF
}

cmd_dev() {
cat << 'EOF'
DEVELOPMENT & TOOLS
======================

PSCALE CLI:
  brew install planetscale/tap/pscale
  pscale auth login

  pscale database create mydb --region us-east
  pscale database list
  pscale shell mydb main                    # SQL shell
  pscale connect mydb main --port 3306      # Local proxy

CONNECT FROM APP:
  # Connection string (from dashboard)
  mysql://username:pscale_pw_xxx@aws.connect.psdb.cloud/mydb?ssl={"rejectUnauthorized":true}

JAVASCRIPT:
  // @planetscale/database (serverless driver)
  import { connect } from '@planetscale/database'
  const conn = connect({
    host: process.env.DATABASE_HOST,
    username: process.env.DATABASE_USERNAME,
    password: process.env.DATABASE_PASSWORD,
  })
  const results = await conn.execute('SELECT * FROM users WHERE id = ?', [userId])

  // Drizzle ORM
  import { drizzle } from 'drizzle-orm/planetscale-serverless'
  const db = drizzle(conn)

  // Prisma
  datasource db {
    provider     = "mysql"
    url          = env("DATABASE_URL")
    relationMode = "prisma"  // Required: no FK constraints
  }

PYTHON:
  import planetscale
  conn = planetscale.connect(
      host="aws.connect.psdb.cloud",
      user="username",
      password="pscale_pw_xxx",
      database="mydb"
  )

PLANETSCALE BOOST (query cache):
  # Enable per-query caching
  # Dashboard → Boost → Enable
  # Caches query results at the edge
  # Automatic invalidation on writes
  # 10-100x faster reads for repeated queries

INSIGHTS:
  # Dashboard → Insights
  # Shows: slow queries, most frequent queries
  # Query latency percentiles (p50, p95, p99)
  # Index recommendations
  # Anomaly detection

NO FOREIGN KEYS — WORKAROUNDS:
  # PlanetScale/Vitess doesn't support FK constraints
  # Enforce referential integrity in application:

  # 1. Application-level checks
  async function createOrder(userId, items) {
    const user = await db.query('SELECT id FROM users WHERE id = ?', [userId])
    if (!user) throw new Error('User not found')
    await db.query('INSERT INTO orders ...')
  }

  # 2. Prisma relationMode = "prisma"
  # Prisma enforces relations without DB-level FK

  # 3. Soft deletes instead of CASCADE
  UPDATE users SET deleted_at = NOW() WHERE id = ?
  -- Instead of: DELETE FROM users (which would CASCADE)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
PlanetScale - Serverless MySQL Platform Reference

Commands:
  intro      Overview, Vitess, comparison
  branching  Schema branches, deploy requests, online DDL
  dev        CLI, drivers, Boost, Insights, FK workarounds

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  branching) cmd_branching ;;
  dev)       cmd_dev ;;
  help|*)    show_help ;;
esac
