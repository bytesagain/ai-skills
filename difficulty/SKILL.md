---
name: "difficulty"
version: "1.0.0"
description: "Analyze difficulty operations. Use when you need to understand difficulty mechanisms, evaluate protocol security, or reference on-chain concepts."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [difficulty, blockchain, cli, tool]
category: "blockchain"
---

# Difficulty

Analyze difficulty operations. Use when you need to understand difficulty mechanisms, evaluate protocol security, or reference on-chain concepts.

## When to Use

- **status**: Show current status
- **add**: Add new entry
- **list**: List all entries
- **search**: Search entries
- **compare**: Compare two inputs
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

Use `scripts/script.sh config <key> <value>` to customize behavior.

| Variable | Description |
|----------|-------------|
| `DIFFICULTY_DIR` | Data directory (default: ~/.difficulty/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
