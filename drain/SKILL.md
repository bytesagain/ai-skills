---
name: "drain"
version: "1.0.0"
description: "Integrate drain operations. Use when you need to configure drain endpoints, manage API connections, or handle service webhooks."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [drain, api, cli, tool]
category: "api"
---

# Drain

Integrate drain operations. Use when you need to configure drain endpoints, manage API connections, or handle service webhooks.

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
| `DRAIN_DIR` | Data directory (default: ~/.drain/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
