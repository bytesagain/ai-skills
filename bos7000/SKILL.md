---
name: "bos7000"
version: "1.0.0"
description: "BOS7000 industrial controller config tool. Use when json bos7000 tasks, csv bos7000 tasks, checking bos7000 status."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [bos7000, industrial, cli, tool]
category: "industrial"
---

# bos7000

BOS7000 industrial controller config tool. Use when json bos7000 tasks, csv bos7000 tasks, checking bos7000 status.
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

| Variable | Description |
|----------|-------------|
| `BOS7000_DIR` | Data directory (default: ~/.bos7000/) |
---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
