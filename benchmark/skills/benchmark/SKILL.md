---
name: "benchmark"
version: "1.0.0"
description: "Run performance benchmarks and stress tests using Python profiling tools. Use when you need to measure, compare, or analyze system and application performance."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [benchmark, general, cli, tool]
category: "general"
---

# benchmark

Run performance benchmarks and stress tests using Python profiling tools. Use when you need to measure, compare, or analyze system and application performance.

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

### `compare`

```bash
scripts/script.sh compare
```

Compare two inputs

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
| `BENCHMARK_DIR` | No | Data directory (default: ~/.benchmark/) |

## Data Storage

All data stored in `~/.benchmark/` using JSONL format (one JSON object per line).

## Output

Structured output to stdout. Exit code 0 on success, 1 on error.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
