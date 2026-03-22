---
name: "hashrate"
version: "1.0.0"
description: "Analyze hashrate operations. Use when you need to understand hashrate mechanisms, evaluate protocol security, or reference on-chain concepts."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [hashrate, blockchain, cli, tool]
category: "blockchain"
---

# Hashrate

Analyze hashrate operations. Use when you need to understand hashrate mechanisms, evaluate protocol security, or reference on-chain concepts.

## When to Use

- **status**: Show current status
- **add**: Add new entry
- **list**: List all entries
- **search**: Search entries
- **remove**: Remove entry by number
- **export**: Export data to file
- **stats**: Show statistics
- **config**: View or set config

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

Use `scripts/script.sh config <key> <value>` to customize behavior.

| Variable | Description |
|----------|-------------|
| `HASHRATE_DIR` | Data directory (default: ~/.hashrate/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
