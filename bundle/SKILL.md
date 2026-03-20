---
name: "bundle"
version: "1.0.0"
description: "Package directories into distributable bundles with manifests. Use when creating release packages, verifying contents, or generating checksums."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# bundle

Package directories into distributable bundles with manifests. Use when creating release packages, verifying contents, or generating checksums.

## Commands

### `create`

```bash
scripts/script.sh create <dir output>
```

### `manifest`

```bash
scripts/script.sh manifest <dir>
```

### `verify`

```bash
scripts/script.sh verify <bundle>
```

### `size`

```bash
scripts/script.sh size <dir>
```

### `list`

```bash
scripts/script.sh list <bundle>
```

### `extract`

```bash
scripts/script.sh extract <bundle dir>
```

## Requirements

- bash 4.0+

## Data Storage

Data stored in `~/.local/share/bundle/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
