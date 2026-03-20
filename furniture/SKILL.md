---
name: "furniture"
version: "1.0.0"
description: "Track home furniture, schedule maintenance, and manage warranty details. Use when cataloging furniture, scheduling cleaning, or tracking warranty expiry dates."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [furniture, general, cli, tool]
category: "general"
---

# furniture

Track home furniture, schedule maintenance, and manage warranty details. Use when cataloging furniture, scheduling cleaning, or tracking warranty expiry dates.

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
| `FURNITURE_DIR` | No | Data directory (default: ~/.furniture/) |

## Data Storage

All data stored in `~/.furniture/` using JSONL format (one JSON object per line).

## Output

Structured output to stdout. Exit code 0 on success, 1 on error.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
