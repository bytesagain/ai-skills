#!/bin/bash
# Neon - Serverless PostgreSQL Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              NEON REFERENCE                                 ║
║          Serverless PostgreSQL                              ║
╚══════════════════════════════════════════════════════════════╝

Neon is serverless PostgreSQL that separates storage and
compute, enabling instant branching, autoscaling to zero,
and bottomless storage.

KEY FEATURES:
  Scale to zero    Compute suspends when idle (saves $$$)
  Branching        Instant database copies (like git branches)
  Autoscaling      0.25 → 8 CU based on load
  Bottomless       Storage grows without limit
  Connection pooling Built-in PgBouncer
  Point-in-time    Restore to any second in retention window
  Standard PG      Full PostgreSQL compatibility (16)

NEON vs RDS vs PLANETSCALE vs SUPABASE:
  ┌──────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Neon     │ RDS      │PlanetScale│ Supabase│
  ├──────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Engine       │ Postgres │ Multiple │ MySQL    │ Postgres │
  │ Serverless   │ Yes      │ No*      │ Yes      │ No       │
  │ Scale to 0   │ Yes      │ No       │ Yes      │ No       │
  │ Branching    │ Instant  │ Snapshot │ Yes      │ No       │
  │ Connection   │ Pooled   │ Manual   │ Pooled   │ Pooled   │
  │ Free tier    │ 512MB    │ 12mo     │ 5GB      │ 500MB    │
  │ Pricing      │ Per-use  │ Per-hour │ Per-use  │ Fixed    │
  └──────────────┴──────────┴──────────┴──────────┴──────────┘

CONNECT:
  # Connection string
  postgresql://user:pass@ep-name-123.us-east-2.aws.neon.tech/dbname

  # With pooler (recommended for serverless apps)
  postgresql://user:pass@ep-name-123.us-east-2.aws.neon.tech/dbname?sslmode=require

  psql "postgresql://user:pass@ep-name-123.us-east-2.aws.neon.tech/dbname"
EOF
}

cmd_branching() {
cat << 'EOF'
BRANCHING & WORKFLOWS
========================

DATABASE BRANCHING (like git):
  # CLI
  neonctl branches create --name dev/feature-x
  neonctl branches create --name staging --parent main
  neonctl branches list
  neonctl branches delete dev/feature-x

  # Branch from a point in time
  neonctl branches create --name debug/investigate \
    --parent main \
    --timestamp "2026-03-24T10:00:00Z"

  # Each branch gets its own connection string
  # Shares storage with parent (copy-on-write)
  # Instant — even for 100GB databases

USE CASES:
  1. Development    Branch per developer/feature
  2. Preview        Branch per PR (auto via CI)
  3. Testing        Branch for test suites (disposable)
  4. Debugging      Branch from production at specific time
  5. Migrations     Test migrations on branch before main

CI/CD INTEGRATION:
  # GitHub Actions
  - name: Create Neon branch
    uses: neondatabase/create-branch-action@v5
    with:
      project_id: ${{ secrets.NEON_PROJECT_ID }}
      branch_name: preview/pr-${{ github.event.number }}
      api_key: ${{ secrets.NEON_API_KEY }}

  # Vercel integration
  # Auto-creates branch per preview deployment
  # Branch deleted when PR is closed

AUTOSCALING:
  # Configure in console or API
  Minimum: 0.25 CU  (compute units)
  Maximum: 8 CU
  Scale-to-zero delay: 5 minutes (configurable)

  # 1 CU ≈ 1 vCPU + 4GB RAM
  # Scale to zero = $0 when idle

POINT-IN-TIME RESTORE:
  neonctl branches create --name restore/fix \
    --parent main \
    --timestamp "2026-03-24T15:30:00Z"
  # Creates branch at exact state of that moment
  # Retention: 7 days (Free), 30 days (Pro)
EOF
}

cmd_dev() {
cat << 'EOF'
DEVELOPMENT & TOOLS
======================

NEON CLI:
  npm install -g neonctl
  neonctl auth

  neonctl projects list
  neonctl branches list --project-id <pid>
  neonctl connection-string --branch dev

NEON SERVERLESS DRIVER:
  // @neondatabase/serverless — works in Edge/Serverless
  import { neon } from '@neondatabase/serverless'

  const sql = neon(process.env.DATABASE_URL)
  const posts = await sql`SELECT * FROM posts WHERE published = true`

  // With parameters (safe from SQL injection)
  const user = await sql`SELECT * FROM users WHERE id = ${userId}`

  // Transaction
  import { neon } from '@neondatabase/serverless'
  const sql = neon(DATABASE_URL)
  const [user] = await sql.transaction([
    sql`INSERT INTO users (name) VALUES (${'Alice'}) RETURNING *`,
    sql`INSERT INTO audit_log (action) VALUES ('user_created')`,
  ])

DRIZZLE ORM + NEON:
  import { drizzle } from 'drizzle-orm/neon-http'
  import { neon } from '@neondatabase/serverless'

  const sql = neon(process.env.DATABASE_URL)
  const db = drizzle(sql)

  const users = await db.select().from(usersTable).where(eq(usersTable.active, true))

PRISMA + NEON:
  // schema.prisma
  datasource db {
    provider = "postgresql"
    url      = env("DATABASE_URL")
  }
  // Use @prisma/adapter-neon for Edge

PYTHON:
  import psycopg2
  conn = psycopg2.connect(DATABASE_URL, sslmode='require')

EXTENSIONS:
  -- Neon supports most PG extensions
  CREATE EXTENSION IF NOT EXISTS pgvector;   -- AI embeddings
  CREATE EXTENSION IF NOT EXISTS postgis;    -- Geospatial
  CREATE EXTENSION IF NOT EXISTS pg_trgm;    -- Fuzzy search
  CREATE EXTENSION IF NOT EXISTS hstore;     -- Key-value

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Neon - Serverless PostgreSQL Reference

Commands:
  intro      Overview, comparison
  branching  Database branches, CI/CD, autoscaling
  dev        CLI, serverless driver, ORMs, extensions

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  branching) cmd_branching ;;
  dev)       cmd_dev ;;
  help|*)    show_help ;;
esac
