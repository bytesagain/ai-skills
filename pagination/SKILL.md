---
name: "pagination"
version: "1.0.0"
description: "Pagination pattern reference — offset, cursor, keyset, and hybrid strategies for APIs and databases. Use when designing paginated endpoints, choosing pagination strategies, or optimizing large dataset traversal."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [pagination, api, database, cursor, offset, keyset, performance]
category: "general"
---

# Pagination — Pagination Pattern Reference

Quick-reference skill for pagination strategies, trade-offs, and implementation patterns.

## When to Use

- Designing paginated REST or GraphQL APIs
- Choosing between offset, cursor, and keyset pagination
- Optimizing database queries for large datasets
- Implementing infinite scroll or page-based navigation
- Debugging pagination edge cases (duplicates, missing items)

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of pagination — why it exists, core concepts, and terminology.

### `offset`

```bash
scripts/script.sh offset
```

Offset-based pagination (LIMIT/OFFSET) — how it works, SQL examples, and pitfalls.

### `cursor`

```bash
scripts/script.sh cursor
```

Cursor-based pagination — opaque tokens, GraphQL Relay spec, implementation details.

### `keyset`

```bash
scripts/script.sh keyset
```

Keyset (seek) pagination — using WHERE clauses instead of OFFSET for O(1) performance.

### `compare`

```bash
scripts/script.sh compare
```

Side-by-side comparison of all pagination strategies with trade-off matrix.

### `pitfalls`

```bash
scripts/script.sh pitfalls
```

Common pagination bugs: phantom reads, duplicates on insert, off-by-one errors.

### `api`

```bash
scripts/script.sh api
```

API design patterns for pagination — headers, link relations, envelope formats.

### `sql`

```bash
scripts/script.sh sql
```

SQL cookbook — optimized queries for each pagination strategy with index advice.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `PAGINATION_DIR` | Data directory (default: ~/.pagination/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
