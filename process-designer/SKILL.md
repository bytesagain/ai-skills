---
name: "process-designer"
version: "1.0.0"
description: "Process flow design and optimization tool. Use when json process designer tasks, csv process designer tasks, checking process designer status."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [process-designer, industrial, cli, tool]
category: "industrial"
---

# process-designer

Process flow design and optimization tool. Use when json process designer tasks, csv process designer tasks, checking process designer status.
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
| `PROCESS_DESIGNER_DIR` | Data directory (default: ~/.process-designer/) |
---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
