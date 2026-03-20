---
name: "decode"
version: "1.0.0"
description: "Decode base64, URLs, JWTs, and encoded formats into readable text. Use when decoding base64, parsing JWT tokens, inspecting encoded payloads."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [decode, general, cli, tool]
category: "general"
---

# decode

Decode base64, URLs, JWTs, and encoded formats into readable text. Use when decoding base64, parsing JWT tokens, inspecting encoded payloads.

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

### `convert`

```bash
scripts/script.sh convert
```

Convert input data

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
| `DECODE_DIR` | No | Data directory (default: ~/.decode/) |

## Data Storage

All data stored in `~/.decode/` using JSONL format (one JSON object per line).

## Output

Structured output to stdout. Exit code 0 on success, 1 on error.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
