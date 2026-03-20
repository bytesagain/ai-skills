---
name: "deploy"
version: "1.0.0"
description: "Deploy applications with health checks and rollback support. Use when pushing releases, checking deploy status, or managing environments."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# deploy

Deploy applications with health checks and rollback support. Use when pushing releases, checking deploy status, or managing environments.

## Commands

### `check`

```bash
scripts/script.sh check <url>
```

### `env`

```bash
scripts/script.sh env
```

### `diff`

```bash
scripts/script.sh diff <f1 f2>
```

### `sync`

```bash
scripts/script.sh sync <src dest>
```

### `verify`

```bash
scripts/script.sh verify <url>
```

### `rollback`

```bash
scripts/script.sh rollback <dir>
```

## Requirements

- bash 4.0+
- curl
- git

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
