---
name: "inverter"
version: "1.0.0"
description: "Inverter and VFD parameter calculator. Use when json inverter tasks, csv inverter tasks, checking inverter status."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [inverter, electrical, cli, tool]
category: "electrical"
---

# inverter

Inverter and VFD parameter calculator. Use when json inverter tasks, csv inverter tasks, checking inverter status.
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
| `INVERTER_DIR` | Data directory (default: ~/.inverter/) |
---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
