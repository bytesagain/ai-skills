---
name: "supabase-tool"
description: "Generate Supabase API curl commands and SQL query helpers. Use when querying tables, counting rows, inserting records, checking database health, auditing RLS policies, or listing tables. No credentials stored — commands are generated for you to run."
---

# supabase-tool

## Triggers on
supabase query, database health, count rows, insert record, rls policy, sql query, supabase table, postgresql

## What This Skill Does
Query, inspect, and manage Supabase databases. Run SQL, count rows, insert records, check health, and audit RLS policies.

## Commands

### query
Run a raw SQL query.
```bash
bash scripts/script.sh query "SELECT COUNT(*) FROM skills WHERE is_ours=true"
```

### select
Query a table with optional filters and limit.
```bash
bash scripts/script.sh select <table> [--limit N] [--filter col=eq.val]
```

### count
Count rows — all tables or a specific one.
```bash
bash scripts/script.sh count
bash scripts/script.sh count skills
```

### insert
Insert a record into a table.
```bash
bash scripts/script.sh insert <table> '<json>'
```

### health
Check API health and response time with row counts.
```bash
bash scripts/script.sh health
```

### rls
Audit RLS policy issues using Supabase Security Advisor.
```bash
bash scripts/script.sh rls
```

### help
Show all available commands.
```bash
bash scripts/script.sh help
```


## Requirements
- bash 4+
- curl
- python3

Powered by BytesAgain | bytesagain.com
