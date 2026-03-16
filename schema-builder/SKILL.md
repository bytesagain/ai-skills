---
version: "2.0.0"
name: schema-builder
description: "Database schema designer. Design table structures, generate SQL DDL, migration scripts, seed data, ER diagrams, optimization reports, NoSQL schemas, and schema diffs. Commands: design, sql, migrate, seed, erd, optimize, nosql, compare. Use for database design, table structure, SQL generation. Use when you need schema builder capabilities. Triggers on: schema builder."
author: BytesAgain
---

# 🗃️ Schema Builder

From requirement to complete database structure in one step.

## Usage

```bash
bash scripts/schema.sh <command> <table_name> [options]
```

## Command Matrix

```
┌──────────┬──────────────────────────────┬───────────────┐
│ Command  │ Description                  │ Output        │
├──────────┼──────────────────────────────┼───────────────┤
│ design   │ Design schema from name      │ Field layout  │
│ sql      │ Generate CREATE TABLE DDL    │ SQL statement │
│ migrate  │ Generate migration script    │ Migration     │
│ seed     │ Generate test/seed data      │ INSERT stmts  │
│ erd      │ ASCII ER diagram             │ Relationship  │
│ optimize │ Index & perf recommendations │ Report        │
│ nosql    │ MongoDB schema               │ JSON schema   │
│ compare  │ Diff two schemas             │ Diff report   │
└──────────┴──────────────────────────────┴───────────────┘
```

## Typical Flow

```
design → sql → migrate → seed
         ↓
       optimize
         ↓
        erd
```

1. `design users` — plan fields and relations
2. `sql users` — generate executable SQL
3. `migrate users` — versioned migration
4. `seed users` — populate test data
5. `optimize users` — check index suggestions

## Supported Databases

- Relational: MySQL, PostgreSQL, SQLite
- NoSQL: MongoDB, Redis (via `nosql` command)
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
