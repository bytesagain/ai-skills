---
name: "archive"
version: "1.0.0"
description: "Create, extract, and manage compressed archives in tar and zip. Use when archiving directories, extracting packages, or verifying checksums."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# archive

Create, extract, and manage compressed archives in tar and zip. Use when archiving directories, extracting packages, or verifying checksums.

## Commands

### `create`

```bash
scripts/script.sh create <dir output>
```

### `extract`

```bash
scripts/script.sh extract <file dir>
```

### `list`

```bash
scripts/script.sh list <file>
```

### `info`

```bash
scripts/script.sh info <file>
```

### `verify`

```bash
scripts/script.sh verify <file>
```

### `split`

```bash
scripts/script.sh split <file size>
```

## Requirements

- bash 4.0+

## Data Storage

Data stored in `~/.local/share/archive/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
