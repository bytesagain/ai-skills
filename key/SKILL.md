---
name: "key"
version: "1.0.0"
description: "Generate, store, and rotate encryption keys and secrets locally. Use when managing API keys, creating passwords, or rotating credentials."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# key

Generate, store, and rotate encryption keys and secrets locally. Use when managing API keys, creating passwords, or rotating credentials.

## Commands

### `generate`

```bash
scripts/script.sh generate <type length>
```

### `store`

```bash
scripts/script.sh store <name value>
```

### `get`

```bash
scripts/script.sh get <name>
```

### `list`

```bash
scripts/script.sh list
```

### `delete`

```bash
scripts/script.sh delete <name>
```

### `rotate`

```bash
scripts/script.sh rotate <name>
```

## Data Storage

Data stored in `~/.local/share/key/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
