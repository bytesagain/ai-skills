---
name: "dedupe"
version: "1.0.0"
description: "Deduplication reference — exact matching, fuzzy matching, hash-based dedup, bloom filters, and data quality. Use when removing duplicate records, files, or data entries."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [dedupe, deduplication, data-quality, hash, fuzzy-match, etl, atomic]
category: "atomic"
---

# Dedupe — Data Deduplication Reference

Quick-reference skill for deduplication strategies, algorithms, and data quality patterns.

## When to Use

- Removing duplicate rows from datasets or databases
- Deduplicating files in storage systems
- Implementing fuzzy matching for near-duplicate detection
- Choosing between exact and probabilistic dedup methods
- Building ETL pipelines with deduplication stages

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of deduplication — types, strategies, and tradeoffs.

### `exact`

```bash
scripts/script.sh exact
```

Exact deduplication — hash-based, key-based, and sorting approaches.

### `fuzzy`

```bash
scripts/script.sh fuzzy
```

Fuzzy deduplication — similarity measures, blocking, and record linkage.

### `files`

```bash
scripts/script.sh files
```

File-level deduplication — fdupes, jdupes, rdfind, and storage dedup.

### `algorithms`

```bash
scripts/script.sh algorithms
```

Dedup algorithms — bloom filters, HyperLogLog, MinHash, SimHash.

### `sql`

```bash
scripts/script.sh sql
```

SQL deduplication patterns — ROW_NUMBER, DISTINCT, GROUP BY strategies.

### `cli`

```bash
scripts/script.sh cli
```

Command-line dedup tools — sort, uniq, awk, and stream processing.

### `checklist`

```bash
scripts/script.sh checklist
```

Deduplication quality checklist and validation steps.

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
| `DEDUPE_DIR` | Data directory (default: ~/.dedupe/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
