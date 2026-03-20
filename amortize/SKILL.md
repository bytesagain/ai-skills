---
name: "amortize"
version: "1.0.0"
description: "Calculate amortize financial metrics and business data. Use when tracking expenses, analyzing investments, or generating financial reports."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [amortize, finance, cli, tool]
category: "finance"
---

# amortize

Calculate amortize financial metrics and business data. Use when tracking expenses, analyzing investments, or generating financial reports.

## Commands

### `calculate`

```bash
scripts/script.sh calculate
```

### `add`

```bash
scripts/script.sh add
```

### `list`

```bash
scripts/script.sh list
```

### `report`

```bash
scripts/script.sh report
```

### `export`

```bash
scripts/script.sh export
```

### `import`

```bash
scripts/script.sh import
```

### `config`

```bash
scripts/script.sh config
```

### `compare`

```bash
scripts/script.sh compare
```

### `forecast`

```bash
scripts/script.sh forecast
```

### `stats`

```bash
scripts/script.sh stats
```

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `AMORTIZE_DIR` | No | Data directory (default: ~/.amortize/) |
| `AMORTIZE_FORMAT` | No | Output format: json, csv, txt (default: json) |

## Data Storage

All data saved on your machine in `~/.amortize/` as JSONL files. Runs entirely on your machine.

## Output

Returns structured output to stdout. Exit code 0 on success, 1 on error.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
