---
name: "test"
version: "1.0.0"
description: "Run test assertions and generate test reports for shell scripts. Use when validating outputs, comparing results, or checking exit codes."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# test

Run test assertions and generate test reports for shell scripts. Use when validating outputs, comparing results, or checking exit codes.

## Commands

### `assert`

```bash
scripts/script.sh assert <expected actual>
```

### `assert-file`

```bash
scripts/script.sh assert-file <f1 f2>
```

### `assert-exit`

```bash
scripts/script.sh assert-exit <code cmd>
```

### `run`

```bash
scripts/script.sh run <dir>
```

### `coverage`

```bash
scripts/script.sh coverage <dir>
```

### `report`

```bash
scripts/script.sh report <logfile>
```

## Data Storage

Data stored in `~/.local/share/test/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
