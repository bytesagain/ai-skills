---
name: "newsletter"
version: "1.0.0"
description: "Manage newsletter content, subscribers, and scheduling using CLI tools. Use when you need to draft, preview, and track newsletter campaigns."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [newsletter, general, cli, tool]
category: "general"
---

# newsletter

Manage newsletter content, subscribers, and scheduling using CLI tools. Use when you need to draft, preview, and track newsletter campaigns.

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
| `NEWSLETTER_DIR` | No | Data directory (default: ~/.newsletter/) |

## Data Storage

All data stored in `~/.newsletter/` using JSONL format (one JSON object per line).

## Output

Structured output to stdout. Exit code 0 on success, 1 on error.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
