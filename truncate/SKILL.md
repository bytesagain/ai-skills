---
name: "truncate"
version: "1.0.0"
description: "Data truncation reference — shortening strings, numbers, files, and database tables safely. Use when implementing text truncation with ellipsis, understanding SQL TRUNCATE vs DELETE, or handling floating-point truncation."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [truncate, shorten, text, sql, file, precision, overflow]
category: "atomic"
---

# Truncate — Data Truncation Reference

Quick-reference skill for truncation operations — strings, numbers, files, and database tables.

## When to Use

- Truncating text with ellipsis for UI display
- Understanding SQL TRUNCATE TABLE vs DELETE
- Handling numeric truncation and precision loss
- Truncating files and log rotation
- Implementing safe multi-byte string truncation

## Commands

### `intro`

```bash
scripts/script.sh intro
```

What truncation means, truncate vs round, common truncation domains.

### `strings`

```bash
scripts/script.sh strings
```

String truncation — ellipsis, word boundary, multi-byte safe, CSS.

### `numbers`

```bash
scripts/script.sh numbers
```

Numeric truncation — integer conversion, floating-point, banker's rounding.

### `sql`

```bash
scripts/script.sh sql
```

SQL TRUNCATE TABLE — vs DELETE, performance, foreign keys, DDL vs DML.

### `files`

```bash
scripts/script.sh files
```

File truncation — truncate command, ftruncate, log rotation, sparse files.

### `overflow`

```bash
scripts/script.sh overflow
```

Truncation and overflow — integer overflow, silent truncation, safety.

### `unicode`

```bash
scripts/script.sh unicode
```

Unicode-safe truncation — grapheme clusters, surrogate pairs, emoji.

### `patterns`

```bash
scripts/script.sh patterns
```

Truncation patterns: middle ellipsis, smart truncate, responsive truncation.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
