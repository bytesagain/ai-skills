---
name: "warehouse"
version: "1.0.0"
description: "Design data warehouse schemas and optimize query pipelines. Use when ingesting datasets, transforming tables, tuning queries, or building aggregations."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [warehouse, general, cli, tool]
category: "general"
---

# warehouse

Design data warehouse schemas and optimize query pipelines. Use when ingesting datasets, transforming tables, tuning queries, or building aggregations.

## Commands

### `status`

```bash
scripts/script.sh status
```

Show current status

### `add`

```bash
scripts/script.sh add
```

Add new entry

### `list`

```bash
scripts/script.sh list
```

List all entries

### `search`

```bash
scripts/script.sh search
```

Search entries

### `remove`

```bash
scripts/script.sh remove
```

Remove entry by number

### `export`

```bash
scripts/script.sh export
```

Export data to file

### `stats`

```bash
scripts/script.sh stats
```

Show statistics

### `config`

```bash
scripts/script.sh config
```

View or set config

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

Use `scripts/script.sh config <key> <value>` to set preferences.

| Variable | Required | Description |
|----------|----------|-------------|
| `WAREHOUSE_DIR` | No | Data directory (default: ~/.warehouse/) |

## Data Storage

All data stored in `~/.warehouse/` using JSONL format (one JSON object per line).

## Output

Structured output to stdout. Exit code 0 on success, 1 on error.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
